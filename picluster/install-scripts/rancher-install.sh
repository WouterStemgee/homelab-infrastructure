#!/bin/bash

# See: https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update
kubectl create namespace cattle-system

helm upgrade --install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.wouterstemgee.be \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=wouterstemgee@gmail.com

kubectl port-forward -n cattle-system rancher-6686db677b-6r9vj 8080:80 8443:443
