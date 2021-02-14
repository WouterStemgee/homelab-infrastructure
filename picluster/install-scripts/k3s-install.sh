#!/bin/bash

# control nodes
ansible control01 -b -m shell -a "curl -sfL https://get.k3s.io | K3S_TOKEN="<random_password>" INSTALL_K3S_VERSION=v1.19.7+k3s1 sh -s - server --cluster-init --disable servicelb --disable traefik"

# extend control plane for high availability
#ansible control02,control03 -b -m shell -a "curl -sfL https://get.k3s.io | K3S_TOKEN="<random_password>" INSTALL_K3S_VERSION=v1.19.7+k3s1 sh -s - server --server https://control01:6443 --disable servicelb --disable traefik"

# worker nodes
ansible workers -b -m shell -a "curl -sfL https://get.k3s.io | K3S_URL="https://control01:6443" K3S_TOKEN="<random_password>" INSTALL_K3S_VERSION=v1.19.7+k3s1 sh -"

# label worker nodes (allow to select workers by label, so we can run pods in production on workers only)
kubectl label nodes worker01 kubernetes.io/role=worker
kubectl label nodes worker01 node-type=worker
kubectl label nodes worker02 kubernetes.io/role=worker
kubectl label nodes worker02 node-type=worker

# save kubeconfig location in the environment
ansible picluster -b -m lineinfile -a "path='/etc/environment' line='KUBECONFIG=/etc/rancher/k3s/k3s.yaml'"

# verify status and labels
kubectl get nodes