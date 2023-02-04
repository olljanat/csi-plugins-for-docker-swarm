# NFS CSI driver for Docker Swarm
[NFS CSI driver](https://github.com/kubernetes-csi/csi-driver-nfs) for Docker Swarm.

**NOTE!!!** This is very early draft which passes build but we have not yet figured out how to make it to use secrets provided by Swarm.


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
docker stack deploy -c docker-compose.yaml test
```
