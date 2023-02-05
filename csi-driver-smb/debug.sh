#!/bin/bash

USAGE="Usage: ./build.sh <SMB CSI version>"

if [ "$1" == "--help" ] || [ "$#" -lt "1" ]; then
	echo $USAGE
	exit 0
fi

docker build --build-arg VERSION=$1 -f Dockerfile.debug -t swarm-csi-smb:debug .

docker run -it --rm \
  --cap-add CAP_SYS_ADMIN \
  --network host \
  -v /etc/hostname:/node_hostname \
  --mount type=tmpfs,destination=/run/docker/plugins \
  swarm-csi-smb:debug
docker rmi swarm-csi-smb:debug
