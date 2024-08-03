https://www.digitalocean.com/community/tutorials/how-to-inspect-kubernetes-networking

- Get pod CIDR
```bash
$ CALICO_KUBECONFIG=/etc/kubernetes/admin.conf DATASTORE_TYPE=kubernetes kubectl-calico get ippool -o wide --allow-version-mismatch
NAME                  CIDR            NAT    IPIPMODE   VXLANMODE   DISABLED   DISABLEBGPEXPORT   SELECTOR   
default-ipv4-ippool   172.16.0.0/16   true   Always     Never       false      false              all()
```

- Get Service CIDR
```bash
$ kubeadm config print init-defaults|tail
...
...
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: registry.k8s.io
kind: ClusterConfiguration
kubernetesVersion: 1.27.0
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}

```