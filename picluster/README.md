# Raspberry Pi Cluster
## Goals
## Requirements
### Hardware
- Raspberry Pi 4
### Ansible
- Install ansible on your local workstation: `sudo apt install ansible`
## Setup
### Nodes
#### Firmware
- Create temporary SD card with the "Raspberry Pi 4 EEPROM boot recovery" for updating the Raspberry Pi firmware and configuring the bootloader. This can be done using the Rasberry Pi Imager application:
    - `sudo apt install rpi-imager`
    - Select "Choose OS -> Misc utility images -> Raspberry Pi 4 EEPROM boot recovery"
- Repeat the following steps for each node:
    - Update Raspberry Pi 4 firmware
        - `sudo rpi-eeprom-update -a`
        - `sudo reboot`
    - Change [boot order](./usb-boot/raspi-firmware-boot-config.sh) in the bootloader:
        1. USB mass-storage devices (USB 3.0)
        2. SD card
    - (Optional: Ubuntu 20.04) Apply [fix](./usb-boot/ubuntu-20.04-boot-fix.sh) to enable booting from USB for Ubuntu 20.04, this step is not neccassary for Ubuntu 20.10
#### Operating System
- Download [Ubuntu Server 20.04 (LTS) 64-bit image](https://ubuntu.com/download/raspberry-pi)
- Flash image to the USB connected drive (SSD)
- Format SD Card
#### Networking
- IP addresses
    - DHCP server: lease IP addresses based on the MAC address of each node
    - Static IP: playbook
- Hostnames
    - playbook: set hostnames, copy /etc/hostnames to all nodes
#### Authentication
- Generate SSH-keypair locally: `ssh-keygen -t rsa`
- Copy the public key to all nodes and disable SSH password authentication
    - Install sshpass: `sudo apt install sshpass`
    - Run ansible playbook: `ansible-playbook -i inventory ssh.yaml --ask-pass`
    - Enter SSH password for user `ubuntu` (default password: `ubuntu`)
- Verify authentication is working: `ansible picluster -i inventory -m ping`
```
worker01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
worker02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
control01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
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


## References
- [Raspberry Pi 4 bootloader configuration
](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711_bootloader_config.md)
- [Raspberry Pi 4 boot EEPROM](https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md)
- [Raspberry Pi 4 Ubuntu 20.04 / 20.10 USB Mass Storage Boot Guide](https://jamesachambers.com/raspberry-pi-4-ubuntu-20-04-usb-mass-storage-boot-guide/)
- [How to install Ubuntu on Raspberry Pi 4 - USB Boot](https://ubuntu.com/tutorials/how-to-install-ubuntu-desktop-on-raspberry-pi-4#4-optional-usb-boot)
- [rpi-eeprom](https://github.com/raspberrypi/rpi-eeprom/tree/master/firmware)