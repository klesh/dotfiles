#!/usr/bin/env fish

sudo pacman -S qemu libvirt virt-manager ebtables dnsmasq virt-viewer

# pcie passthrough
#sudo pacman -S ovmf

sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

# use vm by virsh/virt-viewer
# $ virsh start <VM>
# $ virt-viewer <VM>
