#!/bin/bash

# deploy nginx webserver in namespace "web-wouterstemgee"
kubectl create namespace web-wouterstemgee
kubectl -n web-wouterstemgee apply -f ../ingress/web-wouterstemgee-nginx.yaml 
kubectl get pods --namespace web-wouterstemgee

# create certificate issuer for Let's Encrypt
kubectl apply -f ../ingress/prod-cluster-issuer.yaml

# register ingress route with Traefik
kubectl -n web-wouterstemgee apply -f ../ingress/traefik-ingressroute.yaml

# create certificate request
kubectl -n web-wouterstemgee apply -f ../ingress/web-wouterstemgee-prod-cert.yaml

# verify that certificate was issued successfully
kubectl -n web-wouterstemgee describe certificate wouterstemgee-be-cert

# create middleware to handle HTTP to HTTPS redirect
kubectl -n web-wouterstemgee apply -f ../ingress/traefik-middleware-https-redirect.yaml