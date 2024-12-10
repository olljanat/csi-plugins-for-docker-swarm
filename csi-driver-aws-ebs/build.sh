#!/bin/bash

USAGE="Usage: ./build.sh <Docker Hub Organization> <AWS EBS CSI version>"

if [ "$1" == "--help" ] || [ "$#" -lt "2" ]; then
	echo $USAGE
	exit 0
fi

ORG=$1
# 1.34.0 known to work
# https://github.com/kubernetes-sigs/aws-ebs-csi-driver
VERSION=$2
VERSION_PLATFORM=$2${PLUGIN_PLATFORM:+"-$PLUGIN_PLATFORM"}

rm -rf rootfs
docker plugin disable csi-aws-ebs:latest
docker plugin rm csi-aws-ebs:latest
docker plugin disable $ORG/swarm-csi-aws-ebs:v$VERSION_PLATFORM
docker plugin rm $ORG/swarm-csi-aws-ebs:v$VERSION_PLATFORM
docker rm -vf rootfsimage

docker create --name rootfsimage public.ecr.aws/ebs-csi-driver/aws-ebs-csi-driver:v$VERSION
mkdir -p rootfs
docker export rootfsimage | tar -x -C rootfs
docker rm -vf rootfsimage

docker plugin create $ORG/swarm-csi-aws-ebs:v$VERSION_PLATFORM .
docker plugin enable $ORG/swarm-csi-aws-ebs:v$VERSION_PLATFORM
docker plugin push $ORG/swarm-csi-aws-ebs:v$VERSION_PLATFORM
docker plugin disable $ORG/swarm-csi-aws-ebs:v$VERSION_PLATFORM
docker plugin rm $ORG/swarm-csi-aws-ebs:v$VERSION_PLATFORM
docker plugin install --alias ecs-aws-ebs --grant-all-permissions $ORG/swarm-csi-aws-ebs:v$VERSION_PLATFORM
