# Kubernetes Deployment

- [Kubernetes Deployment](#kubernetes-deployment)
  - [Setup Hosts](#setup-hosts)
  - [Single Node Kubeadm Deployment](#single-node-kubeadm-deployment)


## Setup Hosts
Common OS configuration and install pre-requisites packages. This playbook is included in all kube deployment playbooks, so you can **avoid** manual execution of this playbook.

```bash
INVENTORY=single-node-k8s-hosts
$ ansible-playbook -i inventory/$INVENTORY playbooks/setup-hosts.yml
```

## Single Node Kubeadm Deployment
- Single node Kubeadm deployment consists one master and one or more worker nodes.
- Setup inventory as given in [example](./inventory/single-node-k8s-hosts)

- Run Playbook
```bash
INVENTORY=single-node-k8s-hosts
$ ansible-playbook -i inventory/$INVENTORY playbooks/k8s-deployment.yml
```

