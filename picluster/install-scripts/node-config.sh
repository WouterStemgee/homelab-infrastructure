#!/bin/bash

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

# enable bridged traffic with iptables, add following to a new file "k3s.conf"
echo "net.bridge.bridge-nf-call-ip6tables = 1" > k3s.conf
echo "net.bridge.bridge-nf-call-iptables = 1" > k3s.conf

ansible picluster -b -m copy -a "src=k3s.conf dest=/etc/sysctl.d/k3s.conf owner=root group=root mode=0644"

# disable the green LED (led0)
sudo sh -c 'echo 0 > /sys/class/leds/led0/brightness'

# disable the green LED permanently after reboot by adding parameters to /boot/firmware/config.txt
ansible picluster -b -m shell -a "echo 'dtparam=act_led_trigger=none' >> /boot/firmware/config.txt && echo 'dtparam=act_led_activelow=off' >> /boot/firmware/config.txt"

# reboot
ansible picluster -b -m reboot