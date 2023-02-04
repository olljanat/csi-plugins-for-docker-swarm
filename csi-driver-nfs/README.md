# NFS CSI driver for Docker Swarm
[NFS CSI driver](https://github.com/kubernetes-csi/csi-driver-nfs) for Docker Swarm.

**NOTE!!!** This is very early draft which passes build but we have not yet figured out how to get mounting working. Volume already gets created to NFS share but mounting it to container fails and Docker engine log says:
```
INFO[2023-02-04T19:21:08.939610819+01:00] attempting to publish volume                  attempt=1 module=node/agent/csi volume.id=0f9wq7wvz41wxw81u4gfsiy55
DEBU[2023-02-04T19:21:08.939765667+01:00] staging volume succeeded, attempting to publish volume  attempt=1 module=node/agent/csi volume.id=0f9wq7wvz41wxw81u4gfsiy55
INFO[2023-02-04T19:21:08.939788029+01:00] publishing volume failed                      attempt=1 error="rpc error: code = FailedPrecondition desc = volume not staged" module=node/agent/csi volume.id=0f9wq7wvz41wxw81u4gfsiy55
```


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
docker volume create \
  --driver csi-nfs \
  --availability active \
  --scope single \
  --sharing none \
  --type mount \
  --opt server="172.18.0.1" \
  --opt share="/mnt/nfs_share" \
  my-csi-nfs-volume

docker volume ls --cluster

docker service create \
  --name my-service \
  --mount type=cluster,src=my-csi-nfs-volume,dst=/usr/share/nginx/html \
  --publish 8080:80 \
  nginx

curl http://localhost:8080
```
