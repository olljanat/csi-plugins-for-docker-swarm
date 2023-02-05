#!/bin/sh
set -x

NODE_ID=$(cat /node_hostname)
/nfsplugin \
  -v=5 \
  --drivername=csi-nfs \
  --nodeid=${NODE_ID} \
  --endpoint="unix:///run/docker/plugins/csi-nfs.sock"
