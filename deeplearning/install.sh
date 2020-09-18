#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh


$ROOT/python/install.sh

# install deep learning tools
case "$PM" in
    apt)
        # cuda dependencies
        sudo apt install linux-headers-$(uname -r)

        source /etc/lsb-release
        if [ "$DISTRIB_RELEASE" = "18.04" ] && [ "$(uname -m)" = 'x86_64' ]; then
            wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
            sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
            sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
            sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
            sudo apt-get update
            sudo apt-get -y install cuda
        elif [ "$DISTRIB_RELEASE" = "20.04" ]; then
            sudo apt install nvidia-cuda-toolkit
        else
            echo 'Unsupported release'
            exit -1
        fi
        ;;
    pacman)
        echo TODO
        exit -1
        ;;
esac

