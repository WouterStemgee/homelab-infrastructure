#!/bin/bash

# More details: https://ubuntu.com/tutorials/how-to-install-ubuntu-desktop-on-raspberry-pi-4#4-optional-usb-boot

# Extract the current bootloader configuration to a text file
apt install rpi-eeprom
vcgencmd bootloader_config >bootconf.txt

# Set the BOOT_ORDER option to 0xf14 (meaning attempt USB mass-storage device, then SD card, then repeat)
sed -i -e '/^BOOT_ORDER=/ s/=.*$/=0xf14/' bootconf.txt

# Generate a copy of the EEPROM with the update configuration
rpi-eeprom-config --out pieeprom-new.bin --config bootconf.txt /lib/firmware/raspberrypi/bootloader/critical/pieeprom-2020-09-03.bin

# Set the system to flash the new EEPROM firmware on the next boot
rpi-eeprom-update -d -f ./pieeprom-new.bin
