# Raspberry Pi HomeLab
## Requirements
### Ansible
- Install ansible on your local workstation: `sudo apt install ansible`
## Setup
### Nodes
#### Bootloader
- Update Raspberry Pi 4 firmware
- Change [boot order](./usb-boot/raspi-firmware-boot-config.sh) in the bootloader:
    1. USB Mass Storage (USB 3.0)
    2. SD Card
- Apply [fix](./usb-boot/ubuntu-20.04-boot-fix.sh) to enable booting from USB for Ubuntu 20.04 
#### Operating System
- Download [Ubuntu Server 20.04 (LTS) 64-bit image](https://ubuntu.com/download/raspberry-pi)
- Flash image to the USB connected drive (SSD)
- Format SD Card
#### Authentication
- Generate SSH-keypair locally: `ssh-keygen -t rsa`
- Copy pubkey to all nodes and disable SSH password authentication
    - Install sshpass: `sudo apt install sshpass`
    - Run ansible playbook: `ansible-playbook -i inventory ssh.yaml --ask-pass`
    - Enter SSH password for user `ubuntu` (default password: `ubuntu`)

### Networking
### Storage
### Kubernetes

## Benchmarking
[Storage Benchmarking Script](https://github.com/TheRemote/PiBenchmarks)

## Applications & Services
### Helm
### Rancher
### Longhorn
### Arkade
### OpenFaaS

## License

## References