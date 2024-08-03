# Single Node Kubeadm Deployment

- Single node Kubeadm deployment consists one master and one or more worker nodes.
- Setup inventory as given in [example](../inventory/single-node-k8s-hosts)

## [K8s Node Deployment](./playbooks/k8s-deployment.yml) runs following playbooks in sequence for complete deployment.

Following list illustrate the detailed information of ansible playbook execution to deploy kubernetes cluster.
- [Install Common Packages and Host Setup](./playbooks/common/k8s-prerequisites.yml)
- [Install Kubeadm Packages](./playbooks/common/kubeadm-packages.yml)
- [Deploy Single Node Kubernetes Cluster using Kubeadm](./playbooks/common/single-node-kubeadm.yml)
- [Install CNI](./playbooks/common/cni-provider.yml)
- [Add Worker Node](./playbooks/common/add-worker.yml)
- [Install Ingress Controller](./playbooks/common/ingress-controller.yml)

#### Run Playbook to install cluster
```bash
INVENTORY=single-node-k8s-hosts
$ ansible-playbook -i inventory/$INVENTORY playbooks/k8s-deployment.yml
```
#### Download kubeconfig on localhost
Using below command you can download kube config on localhost, which makes interaction with k8s cluster easy.

```bash
INVENTORY=single-node-k8s-hosts
$ ansible-playbook -i inventory/$INVENTORY playbooks/common/download-kubeconfig.yml
```