# HomeLab Infrastructure
This repository contains all the configuration files describing my personal homelab infrastructure.

## Contents
- [Raspberry Pi Kubernetes Cluster](./picluster)
- [Ubiquiti EdgeRouter Boot Configuration (HomeLab Gateway - Firewall)](./edgerouter/config)
- [Unraid NAS Server](./nas)
- [DataLab Compute Server](./datalab)

## Infrastructure
### Virtualization Server (Proxmox)
High performance virtualization server running multiple VM's and containers. This server will be used as a playground environment for learning the latest DevOps practices and hosting resource intensive applications.

#### Specifications
- Dell PowerEdge R620
	- 2x Intel Xeon Processor E5-2690
		- 8 cores, 16 threads (total of 32 threads)
		- 2.90 GHz - 3.80 GHz
		- 135W TDP
	- 80GB DDR3 ECC RAM
	- 1TB ZFS storage pool (8x 128GB SSD drive)
	- 2x 750W PSU
	- PERC H310 Mini (runnning in IT mode, "software RAID")

### NAS Server (unRAID)
Low power storage home server for streaming/downloading media content and storing data. Server exposes multiple shares to the local home network and a VPN service for securing external access to the local network.

#### Specifications
- ASRock J5005-ITX Motherboard
- Intel Quad-Core Pentium Processor J5005 (up to 2.8GHz)
	- 10W TDP (!)
- 16GB DDR4 2400MHz SO-DIMM RAM
- Samsung 850 EVO 500GB SSD (used for caching, Docker, VM's)
- 4x 4TB WD Red NAS 3.5" SATA-600 HDD (5400rpm)
	- spin-down supported in unRAID for improved efficiency

### Raspberry Pi Cluster (Kubernetes on Ubuntu 20.04)
This cluster will be used primarily as a high availability production environment.

#### Specifications
- 4x Raspberry Pi 4 Model B
	- Broadcom BCM2711, Quad-core Cortex-A72 (ARM v8) 64-bit SoC @1.5GHz
	- 4GB LPDDR4-2400 SDRAM
	- 2.4GHz and 5.0GHz IEEE 802.11ac wireless, Bluetooth 5.0, BLE
	- 2x USB 3.0 ports, 2x USB 2.0 ports
	- 128GB Samsung EVO Plus microSDXC Card
	- 60GB SSD
	- Gigabit ethernet
- TP-Link TL-SG1005P PoE Switch
	- 5x Gigabit including 4x PoE (802.3af)

### Gateway/Firewall
- Ubiquiti EdgeRouter Lite

## License
Licensed under the [MIT license](LICENSE).