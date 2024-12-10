#!/bin/bash

USAGE="Usage: ./build.sh <Docker Hub Organization> <Democratic CSI version>"

if [ "$1" == "--help" ] || [ "$#" -lt "2" ]; then
	echo $USAGE
	exit 0
fi

ORG=$1
VERSION=$2
VERSION_PLATFORM=$2${PLUGIN_PLATFORM:+"-$PLUGIN_PLATFORM"}

rm -rf rootfs
docker plugin disable csi-local-path:latest
docker plugin rm csi-local-path:latest
docker plugin disable $ORG/swarm-csi-local-path:v$VERSION_PLATFORM
docker plugin rm $ORG/swarm-csi-local-path:v$VERSION_PLATFORM
docker rm -vf rootfsimage

docker create --name rootfsimage docker.io/democraticcsi/democratic-csi:v$VERSION
mkdir -p rootfs
docker export rootfsimage | tar -x -C rootfs
docker rm -vf rootfsimage
mkdir -p rootfs/home/csi/app/config
cp entrypoint.sh rootfs/home/csi/app/
cp local-hostpath.yaml rootfs/home/csi/app/config/

docker plugin create $ORG/swarm-csi-local-path:v$VERSION_PLATFORM .
docker plugin enable $ORG/swarm-csi-local-path:v$VERSION_PLATFORM
docker plugin push $ORG/swarm-csi-local-path:v$VERSION_PLATFORM
docker plugin disable $ORG/swarm-csi-local-path:v$VERSION_PLATFORM
docker plugin rm $ORG/swarm-csi-local-path:v$VERSION_PLATFORM
docker plugin install --alias csi-local-path --grant-all-permissions $ORG/swarm-csi-local-path:v$VERSION_PLATFORM
