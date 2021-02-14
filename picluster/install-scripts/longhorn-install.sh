#!/bin/bash

# check status
ansible picluster -b -m shell -a "lsblk -f"

# wipe
ansible picluster -b -m shell -a "wipefs -a /dev/{{ var_disk }}"

# format & mount
ansible picluster -b -m shell -a "mkfs.ext4 /dev/{{ var_disk }}"
ansible picluster -m shell -a "mkdir /storage" -b
ansible picluster -b -m shell -a "mount /dev/{{ var_disk }} /storage"

# show UUID's
ansible picluster -b -m shell -a "blkid -s UUID -o value /dev/{{ var_disk }}"

# modify fstab (automount /storage on boot)
ansible picluster -b -m shell -a "echo 'UUID={{ var_uuid }}  /storage       ext4    defaults        0       2' >> /etc/fstab"
ansible picluster -b -m shell -a "grep UUID /etc/fstab"
ansible picluster -b -m shell -a "mount -a"

# install open-iscsi (longhorn pre-requisite)
ansible picluster -b -m apt -a "name=open-iscsi state=present"

# install longhorn
git clone https://github.com/longhorn/longhorn.git
kubectl create namespace longhorn-system
helm install longhorn ./longhorn/chart/ --namespace longhorn-system --kubeconfig /etc/rancher/k3s/k3s.yaml --set defaultSettings.defaultDataPath="/storage"

# verify installation
kubectl -n longhorn-system get pod

# set longhorn as default storageclass
kubectl get storageclass
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'