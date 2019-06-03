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

```shell
# Install the CustomResourceDefinition resources separately
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml

# Create the namespace for cert-manager
kubectl create namespace cert-manager

# Label the cert-manager namespace to disable resource validation
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true

# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install \
  --name cert-manager \
  --namespace cert-manager \
  --version v0.8.0 \
  jetstack/cert-manager
```

## Copy letsencrypt secrets from the old deployment (if any)

```shell
kubectl get secrets letsencrypt-staging -o yaml -n=kube-system > letsencrypt-staging.yaml
kubectl apply -f letsencrypt-staging.yaml

kubectl get secrets letsencrypt-prod  -o yaml -n=kube-system > letsencrypt-prod.yaml
kubectl apply -f letsencrypt-prod.yaml
```

## Apply cert manager issuers

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
