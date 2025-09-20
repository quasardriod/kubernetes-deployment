# NFS Ganesha server and external provisioner

- [NFS Ganesha server and external provisioner](#nfs-ganesha-server-and-external-provisioner)
  - [Overview](#overview)
  - [Deploy NFS provisioner](#deploy-nfs-provisioner)
  - [Setup RBAC for NFS-Provisioner](#setup-rbac-for-nfs-provisioner)
  - [Create StorageClass](#create-storageclass)

## Overview
**Official Doc:** https://github.com/kubernetes-sigs/nfs-ganesha-server-and-external-provisioner

**NOTE:** `files` directory examples for taken from above git repository.

**Requirements:**
- Ubuntu:
  - Install `nfs-common` package on all master and worker nodes


## Deploy NFS provisioner
1. Define a path available on k8s nodes and use that to store nfs data. In [nfs-provisioner.yaml](./files/nfs-provisioner.yaml), `volumes` properties to be set to define a directory of k8s nodes. 

Currently [nfs-provisioner.yaml](./files/nfs-provisioner.yaml) has set to use `/media` from k8s nodes.

```yaml
volumes:
  - name: export-volume
    hostPath:
      path: /media
```

2. Set a path inside nfs-provisioner pods for mount k8s nodes directory give in above example.

Currently [nfs-provisioner.yaml](./files/nfs-provisioner.yaml) has to mount `/media` from k8s nodes on /export directory inside nfs-provisioner pods.

```yaml
volumeMounts:
  - name: export-volume
    mountPath: /export
```

3. Set provisioner to be used by StorageClass.

Currently [nfs-provisioner.yaml](./files/nfs-provisioner.yaml) has set to expose `localnfs/nfs` as provisioner.

```yaml
    args:
    - "-provisioner=localnfs/nfs"
```

4. Create NFS-Provisioner
```bash
kubectl apply -f roles/files/nfs-provisioner.yaml
```

## Setup RBAC for NFS-Provisioner
```bash
kubectl apply -f roles/files/rbac.yaml
```

## Create StorageClass
[class.yaml](./files/class.yaml) is configured to expose `localnfs` as StorageClass name.

```bash
kubectl apply -f roles/files/class.yaml
```