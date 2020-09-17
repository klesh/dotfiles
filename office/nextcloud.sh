#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh


# install nextcloud
case "$PM" in
    apt)
        echo TODO
        exit -1
        sudo add-apt-repository ppa:nextcloud-devs/client
        sudo apt-get update
        sudo apt install -y nextcloud-client
        ;;
    pacman)
        sudo pacman -S nextcloud-client
        ;;
esac
