# Azure File CSI driver for Docker Swarm
[Azure File CSI driver](https://github.com/kubernetes-sigs/azurefile-csi-driver) for Docker Swarm.

# Build
```bash
./build.sh <Docker Hub Organization> <Azure File CSI version>
```

Because it is hard to see logs from Docker plugin we also have separate `debug.sh` script which will start Azure File  as normal container with the configuration we have created.

# Deployment to other nodes
```bash
docker plugin install \
  --alias csi-azurefile \
  --grant-all-permissions \
  <Docker Hub Organization>/swarm-csi-driver-azure-file:v<Azure File CSI version>
```

# Usage
```bash
# Create volume
docker volume create \
  --driver csi-azurefile \
  --scope single \
  --sharing none \
  --type mount \
  --required-bytes 10G \
  my-csi-driver-azure-file-volume

# Verify that volume state is "created"
docker volume ls --cluster

# Create service
docker service create \
  --name my-service \
  --mount type=cluster,src=my-csi-driver-azure-file-volume,dst=/usr/share/nginx/html \
  --publish 8080:80 \
  nginx

```
