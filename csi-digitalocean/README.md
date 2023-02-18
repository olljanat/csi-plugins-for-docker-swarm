# DigitalOcean CSI driver for Docker Swarm
[DigitalOcean CSI driver](https://github.com/digitalocean/csi-digitalocean) for Docker Swarm.

# Build
```bash
./build.sh <Docker Hub Organization> <DigitalOcean CSI version> <DigitalOcean API URL> <DigitalOcean API Token>
```

Because it hard to see logs from Docker plugin we also have separate `debug.sh` script which will start DigitalOcean plugin as normal container with configration we have created.

In additionally you can mockup DigitalOcean API like this so you don't need have account there to debug CSI driver:
```bash
docker network create --driver=bridge --subnet 169.254.169.0/24 --gateway 169.254.169.1 digitalocean
docker run -d --network digitalocean --ip 169.254.169.254 -v $(pwd)/fake-data:/usr/share/nginx/html --name digitalocean nginx
docker logs -f digitalocean
```
**NOTE!** You need first replace `fake-data/v2/volumes` with:
```json
{
  "volumes": []
}
```
and change it back to current content after you run `docker volume create ...` command. That way you get volume "created" state.

# Deployment to other nodes
```bash
docker plugin install \
  --alias csi-digitalocean \
  --grant-all-permissions \
  <Docker Hub Organization>/swarm-csi-digitalocean:v<DigitalOcean CSI version> \
  DIGITALOCEAN_ACCESS_TOKEN=<api token>
```

# Usage
```bash
# Create volume
docker volume create \
  --driver csi-digitalocean \
  --availability active \
  --scope single \
  --sharing none \
  --type mount \
  --limit-bytes 10G \
  --required-bytes 10G \
  my-csi-digitalocean-volume

# Verify that volume state is "created"
docker volume ls --cluster

# Create service
docker service create \
  --name my-service \
  --mount type=cluster,src=my-csi-digitalocean-volume,dst=/usr/share/nginx/html \
  --publish 8080:80 \
  nginx
```
