# CSI plugins for Docker Swarm
This is my playground repository with CSI plugin which I trying to make working with Docker Swarm.

Target is trying to detect that which CSI plugins can be easily make working (= they don't use Kubernetes specific things or those at least can be disabled) and eventually contribute to original projects.


# Known issues
On Docker 23.0.0 there looks to be at least following issues when working on with CSI plugins.

| Issue                                                                                                             | Reported on         | PR to fix it |
| ----------------------------------------------------------------------------------------------------------------- | ------------------- | ------------ |
| docker plugin create does not support flag `--alias`                                                              |                     |              |
| docker volume create flag --secret does not work with syntax `<key>:<secret name>`, only with `<key>:<secret id>` |                     |              |
| CSI plugins without stagging support does not work properly                                                       |                     | [moby/swarmkit#3116](https://github.com/moby/swarmkit/pull/3116) |
| Cluster volume reference on stack file does not trigger volume creation                                           |                     |              |

