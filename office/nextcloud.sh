#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh


# install nextcloud
case "$PM" in
    apt)
        echo TODO
        exit -1
        ;;
    pacman)
        sudo pacman -S \
            nextcloud-client
        ;;
esac
