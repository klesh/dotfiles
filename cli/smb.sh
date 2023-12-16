#!/bin/sh
# install samba server, useful for sharing folder between guest vm
set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up samba server'

# install server
case "$PM" in
    apt)
        sudo apt install \
            samba
        ;;
    #pacman)
        #sudo pacman -S --noconfirm --needed \
            #openssh
        #;;
esac

if ! [ -f /etc/samba/smb.conf.bak ]; then
    sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
fi
sudo cp $DIR/smb/smb.conf /etc/samba/smb.conf
sudo systemctl restart smbd
echo setting password for smb user
sudo smbpasswd -a klesh
