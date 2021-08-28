#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

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
        #sudo apt install libvirt-daemon-system libvirt-clients virt-manager bridge-utils
        # cli
        case "$DISTRIB_CODENAME" in
            xenial)
                sudo apt install -y qemu-kvm libvirt-bin bridge-utils cpu-checker
                ;;
            focal|bionic)
                sudo apt install -y libvirt-daemon-system libvirt-clients cpu-checker
                ;;
            *)
                echo "unsupported os"
                exit 1
                ;;
        esac
        kvm-ok
        # gui
        if [ -n "$DISPLAY" ] ;then
            sudo apt install -y virt-manager
        else
            sudo apt install -y virtinst
        fi
        ;;
    pacman)
        # TODO
        sudo pacman -S --noconfirm --needed \
            ebtables dnsmasq qemu libvirt virt-manager
        ;;
esac

# configuration
sudo usermod -aG libvirt "$USER"

echo install [spice-guest-tools] on guest os for auto resolution adjustment
