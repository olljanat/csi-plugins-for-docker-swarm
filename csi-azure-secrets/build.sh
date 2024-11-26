#!/bin/bash

USAGE="Usage: ./build.sh <Docker Hub Organization> <azsecret CSI version>"

if [ "$1" == "--help" ] || [ "$#" -lt "2" ]; then
	echo $USAGE
	exit 0
fi

ORG=$1
VERSION=$2

rm -rf rootfs
docker plugin disable csi-azsecret:latest
docker plugin rm csi-azsecret:latest
docker plugin disable $ORG/swarm-csi-azsecret:v$VERSION
docker plugin rm $ORG/swarm-csi-azsecret:v$VERSION
docker rm -vf rootfsimage

docker create --name rootfsimage mcr.microsoft.com/oss/azure/secrets-store/provider-azure:v$VERSION
mkdir -p rootfs
docker export rootfsimage | tar -x -C rootfs
docker rm -vf rootfsimage

docker plugin create $ORG/swarm-csi-azsecret:v$VERSION .
docker plugin enable $ORG/swarm-csi-azsecret:v$VERSION
docker plugin push $ORG/swarm-csi-azsecret:v$VERSION
docker plugin disable $ORG/swarm-csi-azsecret:v$VERSION
docker plugin rm $ORG/swarm-csi-azsecret:v$VERSION
docker plugin install --alias csi-azsecret --grant-all-permissions $ORG/swarm-csi-azsecret:v$VERSION
