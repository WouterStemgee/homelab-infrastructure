#!/bin/bash

# install nmap
apt install nmap

# scan local network range to see who is up
nmap -sP 10.40.0.1-254