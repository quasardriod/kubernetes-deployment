# Kubernetes Deployment

- [Kubernetes Deployment](#kubernetes-deployment)
  - [Overview](#overview)
  - [Setup Hosts](#setup-hosts)
  - [Install Minikube](#install-minikube)
  - [Single Node Kubeadm Deployment](#single-node-kubeadm-deployment)
  - [Download kubeconfig on localhost](#download-kubeconfig-on-localhost)
  - [Install Applications](#install-applications)

## Overview
Supported OS:
- Ubuntu 22.04
  
## Setup Hosts
Common OS configuration and install pre-requisites packages. This playbook is included in all kube deployment playbooks, so you can **avoid** manual execution of this playbook.

```bash
INVENTORY=single-node-k8s-hosts
$ ansible-playbook -i inventory/$INVENTORY playbooks/setup-hosts.yml
```

## Install Minikube
Minikube will be installed with Calico.

```bash
INVENTORY=minikube
$ ansible-playbook -i inventory/$INVENTORY playbooks/minikube.yml
```

## Single Node Kubeadm Deployment
- Single node Kubeadm deployment consists one master and one or more worker nodes.
- Setup inventory as given in [example](./inventory/single-node-k8s-hosts)
- [K8s Node Deployment](./playbooks/k8s-deployment.yml) runs following playbooks in sequence for complete deployment.
  - [Install Common Packages and Host Setup](./playbooks/common/k8s-prerequisites.yml)
  - [Install Kubeadm Packages](./playbooks/common/kubeadm-packages.yml)
  - [Deploy Single Node Kubernetes Cluster using Kubeadm](./playbooks/common/single-node-kubeadm.yml)
  - [Install CNI](./playbooks/common/cni-provider.yml)
  - [Add Worker Node](./playbooks/common/add-worker.yml)
  - [Install Ingress Controller](./playbooks/common/ingress-controller.yml)

- Run Playbook
```bash
INVENTORY=single-node-k8s-hosts
$ ansible-playbook -i inventory/$INVENTORY playbooks/k8s-deployment.yml
```
## Download kubeconfig on localhost
Using below command you can download kube config on localhost, which makes interaction with k8s cluster easy.

```bash
INVENTORY=single-node-k8s-hosts
$ ansible-playbook -i inventory/$INVENTORY playbooks/common/download-kubeconfig.yml
```

## Install Applications
We provide automation for following apps to be installed on kubernetes cluster:
- Nginx

In [Install Application Playbook](./playbooks/common/install-application.yml), `apps_list` contains supported apps and validated against the extra vars provided while running playbook.

- **Deploy Nginx in K8s:**
```bash
$ ansible-playbook -i inventory/localhost playbooks/common/install-application.yml -e app=nginx
```

If you already have kube config, example: `$HOME/.kube/config`, run `kubectl apply` manually.

```bash
$ kubectl apply -f roles/applications-example/nginx-web/files/nginx.yml
```
