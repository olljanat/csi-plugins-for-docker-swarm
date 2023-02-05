#!/bin/sh
set -x

NODE_ID=$(cat /node_hostname)
/smbplugin \
  -v=5 \
  --drivername=csi-smb \
  --nodeid=${NODE_ID} \
  --enable-get-volume-stats=false \
  --endpoint="unix:///run/docker/plugins/csi-smb.sock"
