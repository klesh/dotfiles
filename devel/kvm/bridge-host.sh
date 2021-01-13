#!/bin/sh

# https://wiki.libvirt.org/page/Networking

# ubuntu 16.04
# /etc/network/interfaces
#
# 1. create br0:
# auto br0
# iface br0 inet static
#     bridge_ports enp6s0
#
# 2. move enp6s0 ip setting to br0


create_bridge_on_ubuntu16_host() {
echo "
# set nic to manual
auto enp6s0
iface enp6s0 inet manual

# move nic setting to bridge
auto br0
iface br0 inet static
    bridge_ports enp6s0
    address 10.10.2.3
    netmask 255.255.255.0
    gateway 10.10.2.254
    dns-nameservers 10.10.2.16
    "
sudo reboot
}

disable_netfilter_on_host() {
cat >> sudo tee -a /etc/sysctl.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0
EOF
sudo sysctl -p /etc/sysctl.conf
}

optional_perf_enhance() {
echo "-I FORWARD -m physdev --physdev-is-bridged -j ACCEPT" > /etc/sysconfig/iptables-forward-bridged
lokkit --custom-rules=ipv4:filter:/etc/sysconfig/iptables-forward-bridged
service libvirtd reload
}


change_network_on_guest() {
    sudo virsh edit vmname
    echo "
    <interface type='bridge'>
        <mac address='xx:xx:xx:xx:xx:xx'/>
        <source bridge='br0'/>
        <model type='virtio'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
    </interface>
    "
}
