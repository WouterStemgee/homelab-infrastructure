#!/bin/bash

# create SSH-keypair
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t rsa

# copy keys to each node
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@control01
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@worker01
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@worker02