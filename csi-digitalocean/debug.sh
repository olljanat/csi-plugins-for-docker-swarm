#!/bin/bash

USAGE="Usage: ./build.sh <DigitalOcean CSI version> <DigitalOcean API token>"

if [ "$1" == "--help" ] || [ "$#" -lt "2" ]; then
	echo $USAGE
	exit 0
fi

docker build --build-arg VERSION=$1 -f Dockerfile.debug -t swarm-csi-digitalocean:debug .

docker run -it --rm \
  --cap-add CAP_SYS_ADMIN \
  --network host \
  --mount type=tmpfs,destination=/run/docker/plugins \
  -e DIGITALOCEAN_ACCESS_TOKEN=$2 \
  swarm-csi-digitalocean:debug
docker rmi swarm-csi-digitalocean:debug
