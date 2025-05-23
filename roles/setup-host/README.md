`setup-host` designed to prepare a host for Kubernetes deployment by performing the following tasks:

## Install Common Packages
Installs a set of essential packages based on the operating system family. Ensures the latest versions are installed and updates the package cache.

## Disable Swap
Disables swap on the system to meet Kubernetes requirements.

## Remove Swap Entry from fstab
Ensures that swap is not re-enabled after a system reboot by removing swap-related entries from fstab.

## Set Hostname
Configures the system's hostname to match the inventory hostname, ensuring consistency across the cluster.

## Prepare Hosts Entry
Updates the hosts file with the IP addresses and hostnames of all hosts in the inventory. This is done by gathering inventory details and appending them to the file.

