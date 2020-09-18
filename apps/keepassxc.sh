#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh


# install nextcloud
case "$PM" in
    apt)
        sudo add-apt-repository -y ppa:phoerious/keepassxc
        sudo apt-get update
        sudo apt install -y keepassxc
        ;;
    pacman)
        sudo pacman -S --needed keepassxc
        ;;
esac

