#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh


# install docker
case "$PM" in
    apt)
        sudo apt install -y docker.io docker-compose
        ! which pip3 && $ROOT/python/install.sh
        sudo pip3 install docker-compose
        ;;
    pacman)
        sudo pacman -S --needed docker docker-compose
        ;;
esac

sudo systemctl enable docker
sudo systemctl start docker

# configuration
sudo usermod -aG docker $USER
