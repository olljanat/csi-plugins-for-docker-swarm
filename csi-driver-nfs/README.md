# NFS CSI driver for Docker Swarm
[NFS CSI driver](https://github.com/kubernetes-csi/csi-driver-nfs) for Docker Swarm.

**NOTE!!!** This CSI plugin does **not** work on Docker 23.0.0 because of bug fix https://github.com/moby/swarmkit/pull/3116 is needed.


# Build
```bash
./build.sh <Docker Hub Organization> <NFS CSI version>
```

Because it hard to see logs from Docker plugin we also have separate `debug.sh` script which will start nfsplugin as normal container with configration we have created.

# Deployment to otner nodes
```bash
docker plugin install \
  --alias csi-nfs \
  --grant-all-permissions \
  <Docker Hub Organization>/swarm-csi-nfs:v<NFS CSI version>
```

# Usage
```bash
# Create volume
docker volume create \
  --driver csi-nfs \
  --availability active \
  --scope single \
  --sharing none \
  --type mount \
  --opt server="172.18.0.1" \
  --opt share="/mnt/nfs_share" \
  my-csi-nfs-volume

# Verify that volume state is "created"
docker volume ls --cluster

# Create service
docker service create \
  --name my-service \
  --mount type=cluster,src=my-csi-nfs-volume,dst=/usr/share/nginx/html \
  --publish 8080:80 \
  nginx

# Add example file to NFS share and check that you see that on curl result
echo "<html><h1>Hello World</h1></html>" | sudo tee /mnt/nfs_share/my-csi-nfs-volume/index.html
curl http://localhost:8080
```
