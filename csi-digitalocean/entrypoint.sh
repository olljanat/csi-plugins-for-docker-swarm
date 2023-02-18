#!/bin/sh
set -x

/bin/do-csi-plugin \
  --driver-name=csi-digitalocean \
  --endpoint="unix:///run/docker/plugins/csi-digitalocean.sock" \
  --url="${DIGITALOCEAN_API_URL}" \
  --token="${DIGITALOCEAN_ACCESS_TOKEN}"
