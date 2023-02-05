# SMB CSI driver for Docker Swarm
[SMB CSI driver](https://github.com/kubernetes-csi/csi-driver-smb) for Docker Swarm.

# Build
```bash
./build.sh <Docker Hub Organization> <SMB CSI version>
```

Because it hard to see logs from Docker plugin we also have separate `debug.sh` script which will start smbplugin as normal container with configration we have created.

# Deployment to otner nodes
```bash
docker plugin install \
  --alias csi-smb \
  --grant-all-permissions \
  <Docker Hub Organization>/swarm-csi-smb:v<SMB CSI version>
```

# Usage
```bash
# Create secrets
echo "smb-user" | docker secret create smb-user -
echo "P@ssw0rd!" | docker secret create smb-pwd -

# Create volume
docker volume create \
  --driver csi-smb \
  --availability active \
  --scope single \
  --sharing none \
  --type mount \
  --opt source="//172.18.0.1/smb_share" \
  --secret username=<smb-user secret ID> \
  --secret password=<smb-pwd secret ID> \
  my-csi-smb-volume

# Verify that volume state is "created"
docker volume ls --cluster

# Create service
docker service create \
  --name my-service \
  --mount type=cluster,src=my-csi-smb-volume,dst=/usr/share/nginx/html \
  --publish 8080:80 \
  nginx

# Or alternatively deploy stack
docker stack deploy -c docker-compose.yml web

# Add example file to SMB share and check that you see that on curl result
echo "<html><h1>Hello World</h1></html>" | sudo tee /home/smb-user/smb_share/my-csi-smb-volume/index.html
echo "<html><h1>Hello World</h1></html>" | sudo tee /var/lib/docker/volumes/my-csi-smb-volume/_data/index.html
curl http://localhost:8080
```
