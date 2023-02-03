#!/bin/sh
set -x

NODE_ID=$(cat /node_hostname)
exec /nfsplugin -v=5 --nodeid=${NODE_ID} --endpoint="unix:///run/docker/plugins/csi-nfs.sock"
