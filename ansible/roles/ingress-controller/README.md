# Ingress Controllers

Ingress controller helps to consolidate routing rules of multiple applications into one entity. Ingress controller is exposed to an external network with the help of NodePort or LoadBalancer. You can also use Ingress controller to terminate TLS for your domain in one place, instead of terminating TLS for each application separately.

Kubernetes as a project supports and maintains following ingress controllers.

- AWS
- GCE
- [Nginx](https://github.com/kubernetes/ingress-nginx/blob/main/README.md#readme)

## Installation
- [Nginx](./nginx/README.md)


### Additional Reading
- Review [Official Documentation](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)
- https://cylab.be/blog/154/exposing-a-kubernetes-application-service-hostport-nodeport-loadbalancer-or-ingresscontroller
- https://www.bmc.com/blogs/kubernetes-ingress/
- https://unofficial-kubernetes.readthedocs.io/en/latest/concepts/services-networking/ingress/