#!/bin/bash

USAGE="Usage: ./build.sh <Democratic CSI version>"

if [ "$1" == "--help" ] || [ "$#" -lt "1" ]; then
	echo $USAGE
	exit 0
fi

docker build --build-arg VERSION=$1 -f Dockerfile.debug -t csi-local-path:debug .

docker run -it --rm \
  --cap-add CAP_SYS_ADMIN \
  --network host \
  -v /var/lib/csi-local-hostpath:/var/lib/csi-local-hostpath \
  --mount type=tmpfs,destination=/run/docker/plugins \
  csi-local-path:debug
docker rmi csi-local-path:debug
