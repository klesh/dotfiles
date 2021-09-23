#!/bin/sh

if [ "$#" -lt 1 ] ;then
    echo "Usage: $0 <network> [name] [disk-dir] [iso-path]"
    exit 1
fi

case $1 in
    bridge)
        NETWORK='bridge=br0'
        ;;
    nat)
        NETWORK='network=default'
        ;;
    *)
        NETWORK="type=direct,source=$1,model=virtio"
        ;;
esac

NAME=${2-centos7}
DISKDIR=${3-'vms'}
ISOPATH=${4-'CentOS-7-x86_64-Minimal-2003.iso'}

mkdir -p "$DISKDIR"
sudo virsh destroy "$NAME"
sudo virsh undefine "$NAME"
sudo virt-install \
    --virt-type kvm \
    --name "$NAME" \
    --ram 4096 \
    --vcpus=2 \
    --network "$NETWORK" \
    --nographics \
    --disk "path=$DISKDIR/$NAME.qcow2,size=40,bus=virtio,format=qcow2" \
    --extra-args "console=ttyS0" \
    --location "$ISOPATH"
