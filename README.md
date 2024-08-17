## Overview
Supported OS:
- CentOS 9

## [Install Applications](./applications/README.md)
## [Install Minikube](./docs/minikube.md)
## [Deploy K8s cluster using kubeadm](./docs/kubeadm.md)

## Generate Cluster config for other users
Perform following steps from master node. Review [Certificate Management with kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/) for detailed information.

- See settings of an existing cluster
```bash
$ kubectl get cm kubeadm-config -n kube-system -o=jsonpath="{.data.ClusterConfiguration}"
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: registry.k8s.io
kind: ClusterConfiguration
kubernetesVersion: v1.30.4
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}
```

- Create `ClusterConfiguration` file to be used to generate config
  - Replace `controlPlaneEndpoint` IP address with your cluster endpoint IP address. You can find cluster endpoint IP using `kubectl cluster-info` command.
  - Replace `clusterName` from above command `kubectl get cm kubeadm-config`.
```bash
$ cat generate-user-config.yaml 
  apiVersion: kubeadm.k8s.io/v1beta4
  kind: ClusterConfiguration
  # Will be used as the target "cluster" in the kubeconfig
  clusterName: "kubernetes"
  # Will be used as the "server" (IP or DNS name) of this cluster in the kubeconfig
  controlPlaneEndpoint: "10.64.64.210:6443"
  # The cluster CA key and certificate will be loaded from this local directory
  certificatesDir: "/etc/kubernetes/pki"
```


