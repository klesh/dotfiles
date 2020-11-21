#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up ssh server'

# install sshd
case "$PM" in
    apt)
        sudo apt install \
            openssh-server
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed \
            openssh
        ;;
esac


# start network
sudo systemctl enable ssh
sudo systemctl start ssh
