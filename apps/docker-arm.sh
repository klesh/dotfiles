#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh


# let docker be able to build arm image on x86
if ! docker run --rm -t arm64v8/ubuntu uname -m; then
    case "$PM" in
        apt)
            sudo apt-get install qemu binfmt-support qemu-user-static
            ;;
        pacman)
            # TODO
            ;;
    esac
    sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    sudo docker run --rm -t arm64v8/ubuntu uname -m
fi

