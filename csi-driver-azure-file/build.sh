#!/bin/bash

USAGE="Usage: ./build.sh <Docker Hub Organization> <Azure File CSI version>"

if [ "$1" == "--help" ] || [ "$#" -lt "2" ]; then
	echo $USAGE
	exit 0
fi

ORG=$1
VERSION=$2
VERSION_PLATFORM=$2${PLUGIN_PLATFORM:+"-$PLUGIN_PLATFORM"}

rm -rf rootfs
docker plugin disable csi-driver-azure-file:latest
docker plugin rm csi-driver-azure-file:latest
docker plugin disable $ORG/swarm-csi-driver-azure-file:v$VERSION_PLATFORM
docker plugin rm $ORG/swarm-csi-driver-azure-file:v$VERSION_PLATFORM
docker rm -vf rootfsimage

docker create --name rootfsimage mcr.microsoft.com/oss/kubernetes-csi/azurefile-csi:v$VERSION
mkdir -p rootfs
docker export rootfsimage | tar -x -C rootfs
docker rm -vf rootfsimage

docker plugin create $ORG/swarm-csi-driver-azure-file:v$VERSION_PLATFORM .
docker plugin enable $ORG/swarm-csi-driver-azure-file:v$VERSION_PLATFORM
docker plugin push $ORG/swarm-csi-driver-azure-file:v$VERSION_PLATFORM
docker plugin disable $ORG/swarm-csi-driver-azure-file:v$VERSION_PLATFORM
docker plugin rm $ORG/swarm-csi-driver-azure-file:v$VERSION_PLATFORM
docker plugin install --alias csi-azurefile --grant-all-permissions $ORG/swarm-csi-driver-azure-file:v$VERSION_PLATFORM
