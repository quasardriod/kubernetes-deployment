# [JupyterHub](https://z2jh.jupyter.org/en/stable/jupyterhub/installation.html) Deployment on K8s

**Pre-requisites:**
- helm

## Install JupyterHub
1. Add jhub helm repo

```bash
$ helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
$ helm repo update
```

2. Export jupyterhub default config(Optional)
```bash
$ helm show values jupyterhub/jupyterhub > exported-jhub-config.yaml
```

3. By default, jhub uses default storage class. Set storage class param in export config to use a custom class.

In below example, `localnfs` is a [Ganesha NFS Provisioner](../../roles/nfs-ganesha-server-and-external-provisioner/README.md)

```bash
$ grep  storageClass exported-jhub-config.yaml 
      storageClassName: localnfs
      storageClass: localnfs
```

Use `exported-jhub-config.yaml` file available in repo to deploy jhub, it has a few bug fixes:
- https://discourse.jupyter.org/t/singleuser-pods-stuck-in-pending/6349/4


4. Install jupyterhub

```bash
helm upgrade --cleanup-on-fail \
  --install helm-jhub jupyterhub/jupyterhub \
  --namespace jhub \
  --create-namespace \
  --version=2.0.0 \
  --values exported-jhub-config.yaml
```

5. Post-installation checklist (Output from above command)

- Verify that created Pods enter a Running state:
```bash
kubectl --namespace=default get pod
```

- If a pod is stuck with a Pending or ContainerCreating status, diagnose with:
```bash
kubectl --namespace=default describe pod <name of pod>
```

- If a pod keeps restarting, diagnose with:
```bash
kubectl --namespace=default logs --previous <name of pod>
```

- Verify an external IP is provided for the k8s Service proxy-public.
```bash
kubectl --namespace=default get service proxy-public
```

- If the external ip remains <pending>, diagnose with:
```bash
kubectl --namespace=default describe service proxy-public
```

- Verify web based access:

You have not configured a k8s Ingress resource so you need to access the k8s Service proxy-public directly.

If your computer is outside the k8s cluster, you can port-forward traffic to the k8s Service proxy-public with kubectl to access it from your computer.
```bash
kubectl --namespace=default port-forward service/proxy-public 8080:http
```

Try insecure HTTP access: http://localhost:8080

6. Access application from your desktop
If you do not have LoadBalancer configured in your cluster, you may see `EXTERNAL-IP` in `pending` state for `service/proxy-public`, as in below example

```
service/proxy-public      LoadBalancer   10.107.70.46    <pending>     80:32496/TCP 
```

Run below command to port-forward for `service/proxy-public`.

```bash
$ kubectl --namespace=jhub port-forward --address 0.0.0.0 service/proxy-public 8080:http
```

Access `http://<host-ip>:8080` from browser to access juypterhub from desktop. `host-ip` is the IP of the machine where you run `kubectl port-forward`.