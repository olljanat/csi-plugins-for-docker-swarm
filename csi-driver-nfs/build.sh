#!/bin/bash

USAGE="Usage: ./build.sh <Docker Hub Organization> <NFS CSI version>"

if [ "$1" == "--help" ] || [ "$#" -lt "2" ]; then
	echo $USAGE
	exit 0
fi

ORG=$1
VERSION=$2
VERSION_PLATFORM=$2${PLUGIN_PLATFORM:+"-$PLUGIN_PLATFORM"}

rm -rf rootfs
docker plugin disable csi-nfs:latest
docker plugin rm csi-nfs:latest
docker plugin disable $ORG/swarm-csi-nfs:v$VERSION_PLATFORM
docker plugin rm $ORG/swarm-csi-nfs:v$VERSION_PLATFORM
docker rm -vf rootfsimage

docker create --name rootfsimage registry.k8s.io/sig-storage/nfsplugin:v$VERSION
mkdir -p rootfs
docker export rootfsimage | tar -x -C rootfs
docker rm -vf rootfsimage
cp entrypoint.sh rootfs/

docker plugin create $ORG/swarm-csi-nfs:v$VERSION_PLATFORM .
docker plugin enable $ORG/swarm-csi-nfs:v$VERSION_PLATFORM
docker plugin push $ORG/swarm-csi-nfs:v$VERSION_PLATFORM
docker plugin disable $ORG/swarm-csi-nfs:v$VERSION_PLATFORM
docker plugin rm $ORG/swarm-csi-nfs:v$VERSION_PLATFORM
docker plugin install --alias csi-nfs --grant-all-permissions $ORG/swarm-csi-nfs:v$VERSION_PLATFORM
