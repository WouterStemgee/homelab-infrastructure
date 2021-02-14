#!/bin/bash

ansible workers -b -m shell -a "/usr/local/bin/k3s-agent-uninstall.sh"
ansible control -b -m shell -a "/usr/local/bin/k3s-uninstall.sh"
ansible picluster -b -m shell -a "rm -rf /storage/*"