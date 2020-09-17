#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install gui apps like chromium, vscode, etc...
if [ "$PM" = "pacman" ]; then
    echo TODO
    exit -1
elif [ "$PM" = "apt" ]; then
    sudo apt install chromium-browser
fi
