# Useful commands
## ssh
```bash
# create SSH-keypair
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t rsa

# copy keys to each node
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@control01
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@worker01
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@worker02
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@worker03
```

## nmap
```bash
# install nmap
sudo apt install nmap

# scan local network range to see who is up
nmap -sP 10.40.0.1-254
```

## hostname
```bash
hostnamectl status
hostnamectl set-hostname <hostname>
```

## ansible
### node configuration
```bash
# set hostnames
ansible picluster -b -m shell -a "hostnamectl set-hostname {{ var_hostname }}"
ansible picluster -b -m shell -a "hostnamectl status | grep hostname"

# remove snap
ansible picluster -b -m shell -a "snap remove lxd && snap remove core18 && snap remove snapd"
ansible picluster -b -m shell -a "apt purge snapd -y"
ansible picluster -b -m shell -a "apt autoremove -y"

# update OS
ansible picluster -m apt -a "upgrade=yes update_cache=yes" --become

# enable container support
ansible picluster -b -m shell -a "sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt"

# enable bridged traffic with iptables, add following to a new file: ~/k3s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1

ansible picluster -b -m copy -a "src=~/k3s.conf dest=/etc/sysctl.d/k3s.conf owner=root group=root mode=0644"

# disable the green LED (led0)
sudo sh -c 'echo 0 > /sys/class/leds/led0/brightness'

# disable the green LED permanently after reboot by adding parameters to /boot/firmware/config.txt
ansible picluster -b -m shell -a "echo 'dtparam=act_led_trigger=none' >> /boot/firmware/config.txt && echo 'dtparam=act_led_activelow=off' >> /boot/firmware/config.txt"

# reboot
ansible picluster -b -m reboot
```

### k3s installation
```bash
# control nodes
ansible control01 -b -m shell -a "curl -sfL https://get.k3s.io | K3S_TOKEN="<random_password>" sh -s - server --cluster-init --disable servicelb --disable traefik"
ansible control02,control03 -b -m shell -a "curl -sfL https://get.k3s.io | K3S_TOKEN="<random_password>" sh -s - server --server https://control01:6443 --disable servicelb --disable traefik"

# worker nodes
ansible workers -b -m shell -a "curl -sfL https://get.k3s.io | K3S_URL="https://control01:6443" K3S_TOKEN="<random_password>" sh -"

# label worker nodes (allow to select workers by label, so we can run pods in production on workers only)
kubectl label nodes worker01 kubernetes.io/role=worker
kubectl label nodes worker01 node-type=worker
kubectl label nodes worker02 kubernetes.io/role=worker
kubectl label nodes worker02 node-type=worker
kubectl label nodes worker03 kubernetes.io/role=worker
kubectl label nodes worker03 node-type=worker

# save kubeconfig location in the environment
ansible cube -b -m lineinfile -a "path='/etc/environment' line='KUBECONFIG=/etc/rancher/k3s/k3s.yaml'"

# verify status and labels
kubectl get nodes
```
