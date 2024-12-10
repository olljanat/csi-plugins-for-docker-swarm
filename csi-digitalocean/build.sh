#!/bin/bash

USAGE="Usage: ./build.sh <Docker Hub Organization> <DigitalOcean CSI version> <DigitalOcean API URL> <DigitalOcean API Token>"

if [ "$1" == "--help" ] || [ "$#" -lt "4" ]; then
    echo $USAGE
    exit 0
fi

ORG=$1
VERSION=$2
VERSION_PLATFORM=$2${PLUGIN_PLATFORM:+"-$PLUGIN_PLATFORM"}

rm -rf rootfs
docker plugin disable csi-digitalocean:latest
docker plugin rm csi-digitalocean:latest
docker plugin disable $ORG/swarm-csi-digitalocean:v$VERSION_PLATFORM
docker plugin rm $ORG/swarm-csi-digitalocean:v$VERSION_PLATFORM
docker rm -vf rootfsimage

docker create --name rootfsimage docker.io/digitalocean/do-csi-plugin:v$VERSION
mkdir -p rootfs
docker export rootfsimage | tar -x -C rootfs
docker rm -vf rootfsimage
cp entrypoint.sh rootfs/

docker plugin create $ORG/swarm-csi-digitalocean:v$VERSION_PLATFORM .
docker plugin enable $ORG/swarm-csi-digitalocean:v$VERSION_PLATFORM
docker plugin push $ORG/swarm-csi-digitalocean:v$VERSION_PLATFORM
docker plugin disable $ORG/swarm-csi-digitalocean:v$VERSION_PLATFORM
docker plugin rm $ORG/swarm-csi-digitalocean:v$VERSION_PLATFORM
docker plugin install \
    --alias csi-digitalocean \
    --grant-all-permissions \
    $ORG/swarm-csi-digitalocean:v$VERSION_PLATFORM \
    DIGITALOCEAN_API_URL=$3 \
    DIGITALOCEAN_ACCESS_TOKEN=$4
