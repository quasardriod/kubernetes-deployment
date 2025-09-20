# Nginx Ingress Controller
- [Bare-metal considerations](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/)

## [Bare metal clusters](https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters)
This section is applicable to Kubernetes clusters deployed on bare metal servers, as well as "raw" VMs where Kubernetes was installed manually, using generic Linux distros (like CentOS, Ubuntu...)

For quick testing, you can use a NodePort. This should work on almost every cluster, but it will typically use a port in the range 30000-32767.

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.2/deploy/static/provider/baremetal/deploy.yaml
```
For more information about bare metal deployments (and how to use port 80 instead of a random port in the 30000-32767 range), see [bare-metal considerations](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/).

## Post Installation Insights
In `ingress-nginx` NS following resources will be created:

- `Deployment`: deployment.apps/ingress-nginx-controller
- `Services`:
  - service/ingress-nginx-controller
  - service/ingress-nginx-controller-admission
- `Jobs`:
  - job.batch/ingress-nginx-admission-create
  - job.batch/ingress-nginx-admission-patch


```bash
$ kubectl -n ingress-nginx get all
NAME                                           READY   STATUS      RESTARTS   AGE
pod/ingress-nginx-admission-create-7hjq8       0/1     Completed   0          46s
pod/ingress-nginx-admission-patch-8bqvg        0/1     Completed   0          46s
pod/ingress-nginx-controller-69cb8948f-j54kg   1/1     Running     0          46s

NAME                                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
service/ingress-nginx-controller             NodePort    10.111.79.42    <none>        80:31861/TCP,443:31589/TCP   46s
service/ingress-nginx-controller-admission   ClusterIP   10.101.137.45   <none>        443/TCP                      46s

NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ingress-nginx-controller   1/1     1            1           46s

NAME                                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/ingress-nginx-controller-69cb8948f   1         1         1       46s

NAME                                       STATUS     COMPLETIONS   DURATION   AGE
job.batch/ingress-nginx-admission-create   Complete   1/1           15s        46s
job.batch/ingress-nginx-admission-patch    Complete   1/1           15s        46s

```

## IngressClass
```bash
$ kubectl get ingressclass
NAME    CONTROLLER             PARAMETERS   AGE
nginx   k8s.io/ingress-nginx   <none>       4d4h


$ kubectl get ingressclass -o yaml
apiVersion: v1
items:
- apiVersion: networking.k8s.io/v1
  kind: IngressClass
  metadata:
    annotations:
      ingressclass.kubernetes.io/is-default-class: "true"
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"networking.k8s.io/v1","kind":"IngressClass","metadata":{"annotations":{"ingressclass.kubernetes.io/is-default-class":"true"},"labels":{"app.kubernetes.io/component":"controller"},"name":"nginx"},"spec":{"controller":"k8s.io/ingress-nginx"}}
    creationTimestamp: "2025-05-23T12:01:08Z"
    generation: 1
    labels:
      app.kubernetes.io/component: controller
    name: nginx
    resourceVersion: "23396"
    uid: 4fe484ed-229c-4530-87d7-fdd36a3245e1
  spec:
    controller: k8s.io/ingress-nginx
kind: List
metadata:
  resourceVersion: ""
  selfLink: ""

```

## Ingress-nginx Controller

### Service
- `ingress-nginx-controller` service deployed as NodePort, so to access the application through ingress, we need to access application ingress URL through the `nodePort` for http/https traffic.
- Ingress controller is deployed with NodePort config, as nodes are not load-balanced to use standard port 80/443.

```bash
$ kubectl get service/ingress-nginx-controller -o yaml -n ingress-nginx
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"app.kubernetes.io/component":"controller","app.kubernetes.io/instance":"ingress-nginx","app.kubernetes.io/name":"ingress-nginx","app.kubernetes.io/part-of":"ingress-nginx","app.kubernetes.io/version":"1.12.2"},"name":"ingress-nginx-controller","namespace":"ingress-nginx"},"spec":{"ipFamilies":["IPv4"],"ipFamilyPolicy":"SingleStack","ports":[{"appProtocol":"http","name":"http","port":80,"protocol":"TCP","targetPort":"http"},{"appProtocol":"https","name":"https","port":443,"protocol":"TCP","targetPort":"https"}],"selector":{"app.kubernetes.io/component":"controller","app.kubernetes.io/instance":"ingress-nginx","app.kubernetes.io/name":"ingress-nginx"},"type":"NodePort"}}
  creationTimestamp: "2025-05-23T12:01:08Z"
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
    app.kubernetes.io/version: 1.12.2
  name: ingress-nginx-controller
  namespace: ingress-nginx
  resourceVersion: "6669"
  uid: 206934a4-1524-47c6-b636-307fd1ce5eb7
spec:
  clusterIP: 10.111.79.42
  clusterIPs:
  - 10.111.79.42
  externalTrafficPolicy: Cluster
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - appProtocol: http
    name: http
    nodePort: 31861
    port: 80
    protocol: TCP
    targetPort: http
  - appProtocol: https
    name: https
    nodePort: 31589
    port: 443
    protocol: TCP
    targetPort: https
  selector:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  sessionAffinity: None
  type: NodePort
status:
  loadBalancer: {}

```