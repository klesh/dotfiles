#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# config pip mirror for CHINA
if in-china; then
    lnsf $DIR/pip.conf ~/.pip/pip.conf
    if sudo [ ! -f /root/.pip/pip.conf ]; then
        sudo mkdir -p /root/.pip
        sudo cp $DIR/pip.conf /root/.pip/pip.conf
    fi
fi

# install python3
case "$PM" in
    apt)
        sudo apt install python3 python3-pip python-is-python3
        which fish 2>/dev/null && sudo pip3 install virtualfish
        ;;
    pacman)
        sudo pacman -S --needed python python-pip
        which fish 2>/dev/null && sudo pip install virtualfish
        ;;
esac

# enable auto_activation plugin for virtualfish
which fish 2>/dev/null && fish -c "yes | vf install && vf addplugins auto_activation"


