# AWS EBS CSI driver for Docker Swarm
[AWS EBS CSI driver](https://github.com/kubernetes-sigs/aws-ebs-csi-driver) for Docker Swarm.

**NOTE!!!** This CSI plugin does **not** work on Docker >= 26.0.0 because of bug https://github.com/moby/moby/issues/48133

This functionality has been verified on Docker Swarm v 25.0.x


# Build
```bash
./build.sh <Docker Hub Organization> <AWS EBS CSI version>
```

Because it is hard to see logs from Docker plugin we also have separate `debug.sh` script which will start aws ebs  as normal container with the configuration we have created.

# Deployment to other nodes
```bash
docker plugin install \
  --alias csi-aws-ebs \
  --grant-all-permissions \
  <Docker Hub Organization>/swarm-csi-aws-ebs:v<AWS EBS CSI version>
```

# Usage
```bash
# Create volume
docker volume create \
  --driver csi-aws-ebs \
  --scope single \
  --sharing none \
  --type mount \
  --required-bytes 10G \
  --topology-required topology.kubernetes.io/zone=eu-west-1c
  my-csi-aws-ebs-volume

# Verify that volume state is "created"
docker volume ls --cluster

# Create service
docker service create \
  --name my-service \
  --mount type=cluster,src=my-csi-aws-ebs-volume,dst=/usr/share/nginx/html \
  --publish 8080:80 \
  nginx

```
# Notes

1. This will only work on an EC2 node with an instance profile with IAM policies to use EBS
2. The topology-required zone needs to be set to the same AZ as where the container is running
3. docker compose is not working, I believe compose support for cluster volumes is not implemented yet, will appreciate a moby / docker-compose bug report on this
4. the driver sig rootfs does not contain bash / sh, therefore an entrypoint.sh cannot be used

# Hint
1. Something similar should be possible for the aws efs csi driver.  In all probability the amazon-efs-utils package should be installed on the host and bind mounted to the plugin via config.json
