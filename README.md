# Kubernetes Deployment

- [Overview]
- [Setup Hosts](#setup-hosts)
- [Single Node Kubeadm Deployment](#single-node-kubeadm-deployment)


## Setup Hosts
Common OS configuration and install pre-requisites packages. This playbook is included in all kube deployment playbooks, so you can avoid manual execution of this playbook.

```bash
INVENTORY=single-node-k8s-hosts
$ ansible-playbook -i inventory/$INVENTORY playbooks/setup-hosts.yml
```

## Single Node Kubeadm Deployment
```bash
INVENTORY=single-node-k8s-hosts
$ ansible-playbook -i inventory/$INVENTORY playbooks/single-node-kubeadm.yml
```

