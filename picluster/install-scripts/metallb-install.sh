#!/bin/bash

# create namespace "metallb-system" and deploy MetalLB into it
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml

# create a secret key for the speakers (MetalLB pods) to encrypt speaker communications
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# apply config
kubectl apply -f ../metallb/config.yaml

# check if everything deployed
kubectl get pods -n metallb-system

kubectl get svc --all-namespaces