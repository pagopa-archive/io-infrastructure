# How to deploy the system services

Following, are the instructions to deploy the `cert-manager` and the `nginx-ingress` controller.

All commands below should be run from the system folder.

## Prerequisites

* [Helm client and Tiller](https://docs.microsoft.com/en-us/azure/aks/kubernetes-helm)

>**Note**: To deploy Tiller, create the RBAC using the file and command below:

```shell
kubectl apply -f tiller-rbac-config.yml
```

## Deploy the cert-manager

The cert-manager is a Kubernetes component that takes care of adding and renewing through the integration with some providers (i.e. letsencrypt) certificates for any virtual host specified in the ingress.

> **Warning:** If the first command generates a validation error, you should update the *kubectl* client.

To deploy the cert-manager follow the instructions from the [official website](https://docs.cert-manager.io/en/latest/getting-started/install/kubernetes.html).

## Apply cert manager issuers

This will integrate the cert-manager with the letsencrypt certificate issuer.

```shell
kubectl apply -f cert-manager-issuers.yml
```

## Deploy the ingress controller

Create a name space for `nxignx-ingress`:

```shell
kubectl create namespace ingress
```

```shell
helm install stable/nginx-ingress \
    --namespace ingress \
    -n io \
    -f nginx-ingress-custom.yml \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
```

## Apply the ingress rules

```shell
kubectl apply -f ingress-rules.yml
```
