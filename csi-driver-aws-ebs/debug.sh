#!/bin/bash

USAGE="Usage: ./build.sh <AWS EBS CSI version>"

if [ "$1" == "--help" ] || [ "$#" -lt "1" ]; then
	echo $USAGE
	exit 0
fi

docker build --build-arg VERSION=$1 -f Dockerfile.debug -t swarm-csi-aws-ebs:debug .

docker run -it --rm \
  --cap-add CAP_SYS_ADMIN \
  --network host \
  -v /dev:/dev \
  --mount type=tmpfs,destination=/run/docker/plugins \
  swarm-csi-aws-ebs:debug
docker rmi swarm-csi-aws-ebs:debug
