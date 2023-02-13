# CSI plugins for Docker Swarm
This is my playground repository with CSI plugins which I trying to make working with Docker Swarm. Contributions to improve documentation and add more examples are very welcome.

It is recommended to read [official documentation](https://github.com/moby/moby/blob/master/docs/cluster_volumes.md) first before playing with these.

Target is trying to detect that which CSI plugins can be easily make working (= they don't use Kubernetes specific things or those at least can be disabled) and eventually contribute to original projects.

# Known issues
On Docker 23.0.0 there looks to be at least following issues when working on with CSI plugins.

| Issue                                                                                                             | Reported on         | PR to fix it |
| ----------------------------------------------------------------------------------------------------------------- | ------------------- | ------------ |
| docker plugin create does not support flag `--alias`                                                              |                     |              |
| docker volume create flag --secret does not work with syntax `<key>:<secret name>`, only with `<key>:<secret id>` |                     |              |
| CSI plugins without stagging support does not work properly                                                       |                     | [moby/swarmkit#3116](https://github.com/moby/swarmkit/pull/3116) |
| Cluster volume reference on stack file does not trigger volume creation                                           |                     |              |
| Docker Swarm does not support resizing CSI volumes                                                                | [moby/moby#44985](https://github.com/moby/moby/issues/44985) |
| Docker Swarm does not work properly with CSI drivers that do not support nodepublish                               |                    | [moby/swarmkit/3116](https://github.com/moby/swarmkit/pull/3116) |

# Feature requests for Docker Swarm support on existing CSI plugin projects
These are known feature requests to add Docker Swarm support to existing CSI plugins:
| Plugin                              | Feature request                                                                                              |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| DigitalOcean CSI                    | [digitalocean/csi-digitalocean#57](https://github.com/digitalocean/csi-digitalocean/issues/57)               |
| Hetzner Cloud CSI                   | [hetznercloud/csi-driver#374](https://github.com/hetznercloud/csi-driver/issues/374)                         |
| NFS CSI                             | [kubernetes-csi/csi-driver-nfs#/40](https://github.com/kubernetes-csi/csi-driver-nfs/issues/408)             |
| Nutanix CSI                         | [nutanix/helm#/92](https://github.com/nutanix/helm/issues/92)                                                |
| SeaweedFS CSI                       | [seaweedfs/seaweedfs-csi-driver#98](https://github.com/seaweedfs/seaweedfs-csi-driver/issues/98)             |
| SMB CSI                             | [kubernetes-csi/csi-driver-smb#576](https://github.com/kubernetes-csi/csi-driver-smb/issues/576)             |
| Synology CSI                        | [SynologyOpenSource/synology-csi#28](https://github.com/SynologyOpenSource/synology-csi/issues/28)           |
| VMware vSphere CSI                  | [kubernetes-sigs/vsphere-csi-driver#2191](https://github.com/kubernetes-sigs/vsphere-csi-driver/issues/2191) |


# Non-compatible CSI plugins
These CSI plugins are known to use Kubernetes specific implementation which why it is not possible to make them working with Docker Swarm without big changes to their implementation.

| Plugin                              | Problem description                                                                                | Related issue |
| ----------------------------------- | -------------------------------------------------------------------------------------------------- | ------------- |
| [Longhorn](https://longhorn.io)     | Works as [Kubernetes controller](https://kubernetes.io/docs/concepts/architecture/controller/)     | [longhorn/longhorn#23](https://github.com/longhorn/longhorn/issues/23) |
