#!/bin/bash

USAGE="Usage: ./build.sh <azsecret CSI version>"

if [ "$1" == "--help" ] || [ "$#" -lt "1" ]; then
	echo $USAGE
	exit 0
fi

docker run -it --rm \
  --network host \
  --mount type=tmpfs,destination=/run/docker/plugins \
  mcr.microsoft.com/oss/azure/secrets-store/provider-azure:v$1 \
  --v=5 \
  --construct-pem-chain=true \
  --endpoint="unix:///run/docker/plugins/csi-azsecret.sock"
