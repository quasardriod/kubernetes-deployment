# Nginx Ingress Controller

NGINX Ingress Controller is a very popular Ingress for Kubernetes. In many cloud environments, it can be exposed to an external network by using the load balancer offered by the cloud provider. However, cloud load balancers are not necessary. Load balancer can also be implemented with MetalLB, which can be deployed in the same Kubernetes cluster. Another option to expose the Ingress controller to an external network is to use NodePort. Both of these alternatives are described in more detail on below, with separate examples.

- We are exposing Ingress Controller using NodePort, controlled using `expose_method` var. Review [Default Vars](./defaults/main.yml) for more information.
- While running playbook, pass `-e expose_method=lb` to install Ingress Controller with LoadBalancer service type

## Installation
- Run Playbook
```bash
$ ansible-playbook -i inventory/single-node-k8s-hosts playbooks/common/ingress-controller.yml
```

### Additional Reading
- Review [Official Documentation](https://kubernetes.github.io/ingress-nginx/deploy/)
- https://docs.k0sproject.io/v1.23.6+k0s.2/examples/nginx-ingress/
- [IngressClass](https://kubernetes.io/docs/concepts/services-networking/ingress/#default-ingress-class)
- https://docs.nginx.com/nginx-ingress-controller/intro/how-nginx-ingress-controller-works/
