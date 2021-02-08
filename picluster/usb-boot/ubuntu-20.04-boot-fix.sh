#!/bin/bash

# More details: https://jamesachambers.com/raspberry-pi-4-ubuntu-20-04-usb-mass-storage-boot-guide/

mkdir /mnt/boot
mkdir /mnt/writable
mount /dev/sda1 /mnt/boot
mount /dev/sda2 /mnt/writable

curl https://raw.githubusercontent.com/TheRemote/Ubuntu-Server-raspi4-unofficial/master/BootFix.sh | bash
