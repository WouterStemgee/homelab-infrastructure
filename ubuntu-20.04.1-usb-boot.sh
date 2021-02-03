#!/bin/bash


# Extract the current bootloader configuration to a text file
vcgencmd bootloader_config > bootconf.txt

# Set the BOOT_ORDER option to 0xf41 (meaning attempt SD card, then USB mass-storage device, then repeat)
sed -i -e '/^BOOT_ORDER=/ s/=.*$/=0xf41/' bootconf.txt

# Generate a copy of the EEPROM with the update configuration
apt install rpi-eeprom
rpi-eeprom-config --out pieeprom-new.bin --config bootconf.txt /lib/firmware/raspberrypi/bootloader/critical/pieeprom-2020-09-03.bin

# Set the system to flash the new EEPROM firmware on the next boot
rpi-eeprom-update -d -f ./pieeprom-new.bin
