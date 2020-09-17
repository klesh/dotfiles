#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# check dependencies
! which yarnpkg && $ROOT/nodejs/install.sh

# install nvim
case "$PM" in
    apt)
        sudo add-apt-repository ppa:neovim-ppa/stable -y
        sudo apt update
        sudo apt install -y neovim
        ;;
    pacman)
        sudo pacman -S neovim
        ;;
esac

# symlink configuration
lnsf $DIR/config ~/.config/nvim
