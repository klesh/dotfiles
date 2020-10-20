#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# tips
# 1. to relocate default pool
#    ```
#    virsh pool-destroy default
#    virsh pool-edit default   # modify the `update` node
#    virsh pool-start default
#    ```
# 2. create non-preallocated storage image file (slower performance but smaller size for copying)
#    `qemu-img create -o preallocation=off -f qcow2 /path/to/img.qcow2 10G`
# 3. connecting to guest os prerequiste: use system session / guest nic source uses NAT


# install tools for kvm
case "$PM" in
    apt)
        sudo apt install libvirt-daemon-system libvirt-clients virt-manager bridge-utils
        ;;
    pacman)
        # TODO
        ;;
esac

# configuration
sudo usermod -aG libvirt $USER
