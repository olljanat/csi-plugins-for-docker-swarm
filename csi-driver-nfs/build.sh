#!/bin/bash

USAGE="Usage: ./build.sh VERSION"

if [ "$1" == "--help" ] || [ "$#" -lt "1" ]; then
	echo $USAGE
	exit 0
fi

VERSION=$1

rm -rf build
docker plugin disable csi-nfs:latest
docker plugin rm csi-nfs:latest

ID=$(docker create --name rootfsimage registry.k8s.io/sig-storage/nfsplugin:v$VERSION)
mkdir -p rootfs
cp start.sh rootfs/
docker export "$ID" | tar -x -C rootfs
docker rm -vf "$ID"
docker rmi registry.k8s.io/sig-storage/nfsplugin:v$VERSION

docker plugin create ollijanatuinen/swarm-csi-nfs:v$VERSION .
docker plugin enable ollijanatuinen/swarm-csi-nfs:v$VERSION 
docker plugin push ollijanatuinen/swarm-csi-nfs:v$VERSION
docker plugin rm ollijanatuinen/swarm-csi-nfs:v$VERSION
docker plugin install --alias csi-nfs --grant-all-permissions ollijanatuinen/swarm-csi-nfs:v$VERSION
