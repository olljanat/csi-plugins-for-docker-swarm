# Azure Key Vault CSI driver for Docker Swarm
[Azure Key Vault CSI driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure) for Docker Swarm.

# Build
```bash
./build.sh <Docker Hub Organization> <Azure Key Vault CSI version>
```

Because it hard to see logs from Docker plugin we also have separate `debug.sh` script which will start smbplugin as normal container with configration we have created.

# Deployment to otner nodes
```bash
docker plugin install \
  --alias csi-azsecret \
  --grant-all-permissions \
  <Docker Hub Organization>/swarm-csi-azsecret:v<Azure Key Vault CSI version>
```

# Usage
```bash
# Create volume
docker volume create \
  --driver csi-azsecret \
  --availability active \
  --scope single \
  --sharing readonly \
  --type mount \
  --opt usePodIdentity="false" \
  --opt useVMManagedIdentity="false" \
  --opt userAssignedIdentityID="" \
  --opt keyvaultName="kv-euw-aditro-opx-w" \
  --opt cloudName="AzurePublicCloud" \
  my-csi-azsecret-volume

# Verify that volume state is "created"
docker volume ls --cluster

# Create service
docker service create \
  -d \
  --name my-service \
  --mount type=cluster,src=my-csi-azsecret-volume,dst=/secret \
  --publish 8080:80 \
  nginx
```
