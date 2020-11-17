#!/bin/bash

# need exfat-utils on archlinux


set -e

# ensure target path is mounted
DRIVE_PATH=${1-'/mnt/hgst3t'}
if ! mountpoint -q -- "$DRIVE_PATH"; then
    echo "$DRIVE_PATH is not mounted"
    exit -1
fi

# get device
DEV=$(grep -F "$DRIVE_PATH" /proc/mounts | awk '{print $1}')


# stop services that might using this target drives
sudo systemctl stop transmission
sudo systemctl stop smb

if sudo lsof $DRIVE_PATH 2>/dev/null; then
    $DRIVE_PATH is being used
    exit -1
fi

# create archive index file
read -p "Please enter archive number: " NUM
[ "$NUM" -ne "$NUM" ] && echo $NUM is not a number && exit -1
tree -L 2 $DRIVE_PATH/movies > ~/hgst3t-$NUM.txt

# remove mounting record from fstab
sed "\#$DRIVE_PATH\s#d" /etc/fstab | sudo tee /etc/fstab

sudo umount $DRIVE_PATH
echo you can safely remove $DRIVE_PATH now

