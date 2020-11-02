#!/bin/sh

DIR=$(readlink -f "$(dirname "$0")")
. "$DIR/../env.sh"

# install sshd
case "$PM" in
    apt)
        sudo apt install \
            openssh-server
        ;;
    pacman)
        sudo pacman -S --needed \
            openssh
        ;;
esac


# start network
sudo systemctl enable ssh
sudo systemctl start ssh
