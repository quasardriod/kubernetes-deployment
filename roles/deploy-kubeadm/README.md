# Install Kubernetes using Kubeadm

- [Install Kubernetes using Kubeadm](#install-kubernetes-using-kubeadm)
  - [Overview](#overview)
  - [Kubeadm Config](#kubeadm-config)
  - [Post Kubeadm Installation](#post-kubeadm-installation)
      - [Coredns](#coredns)

## Overview
Review [Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network) for detailed information.

## Kubeadm Config
Review [Kubeadm Config](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-config/) for detailed information.

We can initialize k8s cluster using custom kubeadm config. Generate kubeadm config using below example, tweak the config and pass using --config in `kubeadm init`.

```bash
$ kubeadm config print init-defaults
```

## Post Kubeadm Installation

#### Coredns
You will see coredns pods are in `Pending` state after installing kubeadm, that is due to missing CNI Network. Review [Install CNI](../cni/README.md) for if you need to install CNI provider manually. 