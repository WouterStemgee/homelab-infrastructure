#!/bin/bash

# See:  https://cert-manager.io/docs/installation/kubernetes/
#       https://cert-manager.io/docs/configuration/acme/http01/
#       https://cert-manager.io/docs/usage/certificate/

# add the Helm repository and install Traefik on the "traefik" namespace
helm repo add traefik https://containous.github.io/traefik-helm-chart
helm repo update

kubectl create namespace traefik
helm install --namespace traefik traefik traefik/traefik --values ../ingress/traefik-helm-values.yaml

# expose Traefik dashboard using a port-forward
kubectl port-forward -n traefik $(kubectl get pods -n traefik --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000

# create "cert-manager" namespace
kubectl create namespace cert-manager

# install cert-manager custom resource definitions for kubernetes (CRD)
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.crds.yaml

# install cert-manager using Helm
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.1.0 \

# verify installation
kubectl get pods --namespace cert-manager