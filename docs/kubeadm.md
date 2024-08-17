# Kubernetes Deployment using Kubeadm

- Single node Kubeadm deployment consists one master and one or more worker nodes.
- Setup inventory as given in [example](../inventory/k8s-inv)

## [K8s Nodes Deployment](./playbooks/k8s-deployment.yml) runs following playbooks in sequence for complete deployment.

Following list illustrate the detailed information of ansible playbook execution to deploy kubernetes cluster.
- [Install Common Packages and Host Setup](./playbooks/common/k8s-prerequisites.yml)
- [Install Kubeadm Packages](./playbooks/common/kubeadm-packages.yml)
- [Deploy Single Node Kubernetes Cluster using Kubeadm](./playbooks/common/single-node-kubeadm.yml)
- [Install CNI](./playbooks/common/cni-provider.yml)
- [Add Worker Node](./playbooks/common/add-worker.yml)
- [Install Ingress Controller](./playbooks/common/ingress-controller.yml)

## Install Kubernetes Cluster using Kubeadm
**NOTE:** Follow below steps when running k8s nodes in Openstack Cloud:
  - User must attach floating ip to k8s master before starting k8s deployment.
  - Define `master_floating_ip` var in k8s master node group in inventory file.
```
[master:vars]
# Set only when running k8s env in openstack
master_floating_ip: '0.0.0.0'
```

#### Start Deployment
```bash
./run.sh inventory/<inventory_file>
```

#### Access kubernetes cluster from external network
Following these steps when k8s cluster running in OpenStack Cloud:
- Copy `/etc/kubernetes/admin.conf` from kube master to the client in `~/.kube/config`
- Change `server` param IP/hostname to `floating IP` of the kube master in `~/.kube/config`
