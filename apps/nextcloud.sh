#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"


# install nextcloud
case "$PM" in
    apt)
        sudo add-apt-repository -y ppa:nextcloud-devs/client
        sudo apt-get update
        sudo apt install -y nextcloud-client
        ;;
    pacman)
        sudo pacman -S --needed nextcloud-client
        ;;
esac
