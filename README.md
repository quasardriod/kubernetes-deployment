# Kubernetes Deployment

- [Kubernetes Deployment](#kubernetes-deployment)
  - [Overview](#overview)
  - [Setup Hosts](#setup-hosts)
  - [Install Minikube](#install-minikube)
  - [Deploy K8s cluster using kubeadm](#deploy-k8s-cluster-using-kubeadm)
  - [Install NFS Provisioner](#install-nfs-provisioner)
  - [Install Applications](#install-applications)
      - [Juypyterhub](#juypyterhub)

## Overview
Supported OS:
- Ubuntu 22.04
  
## Setup Hosts
Common OS configuration and install pre-requisites packages. This playbook is included in all kube deployment playbooks, so you can **avoid** manual execution of this playbook.

```bash
INVENTORY=single-node-k8s-hosts
$ ansible-playbook -i inventory/$INVENTORY playbooks/setup-hosts.yml
```

## [Install Minikube](./docs/minikube.md)

## [Deploy K8s cluster using kubeadm](./docs/kubeadm.md)

## [Install NFS Provisioner](./roles/nfs-ganesha-server-and-external-provisioner/README.md)

## [Install Applications](./applications/README.md)

#### [Juypyterhub](./applications/jupyterhub/README.md)