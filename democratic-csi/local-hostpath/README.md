# local-hostpath driver
[Democratic CSI](https://github.com/democratic-csi/democratic-csi) with [local-hostpath driver configuration](https://github.com/democratic-csi/democratic-csi/blob/v1.7.7/examples/local-hostpath.yaml) for Docker Swarm.

# Build
```bash
sudo mkdir -p /var/lib/csi-local-hostpath/v/my-csi-local-volume
echo "<html><h1>Hello World</h1></html>" | sudo tee /var/lib/csi-local-hostpath/v/my-csi-local-volume/index.html
sudo chmod -R 0777 /var/lib/csi-local-hostpath
./build.sh <Docker Hub Organization> <Democratic CSI version>
```

Because it hard to see logs from Docker plugin we also have separate `debug.sh` script which will start democratic-csi as normal container with configration we have created.

# Deployment to otner nodes
```bash
sudo mkdir -p /var/lib/csi-local-hostpath/v/my-csi-local-volume
echo "<html><h1>Hello World</h1></html>" | sudo tee /var/lib/csi-local-hostpath/v/my-csi-local-volume/index.html
sudo chmod -R 0777 /var/lib/csi-local-hostpath
docker plugin install \
  --alias csi-local-path \
  --grant-all-permissions \
  <Docker Hub Organization>/swarm-csi-local-path:v<Democratic CSI version>
```

# Usage
```bash
# Create volume
docker volume create \
  --driver csi-local-path \
  --availability active \
  --scope single \
  --sharing none \
  --type mount \
  my-csi-local-volume

# Verify that volume state is "created"
docker volume ls --cluster

# Create service
docker service create \
  --name my-service \
  --mount type=cluster,src=my-csi-local-volume,dst=/usr/share/nginx/html \
  --publish 8080:80 \
  nginx

# Verity that we see Hello World" message coming from nginx
curl http://localhost:8080
```
