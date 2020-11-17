#!/bin/bash

set -e

MOUNT_PATH=${1-'/mnt/hgst3t'}

# find all umounted devices/partions and deal with them
rm -rf /tmp/umounted_devs
IFS=' '
NUM=1
lsblk --noheadings --raw | while read -ra INFO; do
    DEV="${INFO[0]}"
    SIZE="${INFO[3]}"
    TYPE="${INFO[5]}"
    MOUNT="${INFO[6]}"
    # skip mounted entry
    #blkid | grep -F "/dev/$DEV" > /dev/null &&  continue
    echo " $NUM)	/dev/$DEV		$SIZE	$TYPE" >> /tmp/umounted_devs
    NUM=$(($NUM+1))
done


if [ ! -s /tmp/umounted_devs ]; then
    echo "no operatable drive/partition found"
    exit -1
fi


echo
echo Pick a drive/partition to process
echo
cat /tmp/umounted_devs
echo

read -p "Please enter the line number: " NUM

LINE=$(sed -n "${NUM}p" /tmp/umounted_devs)
IFS='	' read LN DEV SIZE TYPE <<< $LINE

echo
echo You selected $TYPE $DEV with size of $SIZE
echo


init_drive() {
echo "g
n
1


y
w" | sudo fdisk $DEV
}

init_partition() {
    echo formating partition $1
    sudo umount $1 || true
    sudo mkfs.exfat $1
}

mount_partition() {
    # remove mounting record from fstab
    sed "\#$MOUNT_PATH\s#d" /etc/fstab | sudo tee /etc/fstab
    UUID=$(sudo blkid -s UUID -o value $1)
    echo "UUID=$UUID $MOUNT_PATH exfat auto,user,rw,async 0 0" | sudo tee -a /etc/fstab
    mkdir -p $MOUNT_PATH
    sudo mount -a
    mkdir -p $MOUNT_PATH/movies
    sudo systemctl start transmission
    sudo systemctl start smb
}


# disk selected
if [ "$TYPE" = "disk" ]; then
    NUM=$(ls -l $DEV* | wc -l)
    # alert if drive already has partition
    if [ $NUM -gt 1 ]; then
        read -p "partitions found on $DEV, are u sure to initialize this drive? [y/N]: " CONFIRM
        [ "$CONFIRM" != 'y' ] && exit -1
    fi
    init_drive
    # format newly created partition on that dev
    PART=$(ls $DEV* | tail -1)
    init_partition $PART
    mount_partition $PART
# partition selected
elif [ "$TYPE" = "part" ]; then
    # partition is unformatted
    if [ -z "$(blkid $DEV)" ] ; then
        init_partition $DEV
    # partition is not exfat format
    elif blkid $DEV | grep -Fv exfat > /dev/null; then
        read -p "all data on $DEV will be destroyed, are u sure? [y/N]: " CONFIRM
        [ "$CONFIRM" != 'y' ] && exit -1
        init_partition $DEV
    fi
    # now, we known partition is exfat format
    mount_partition $DEV
fi

