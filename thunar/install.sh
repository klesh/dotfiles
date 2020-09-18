#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install ranger
case "$PM" in
    apt)
        sudo apt install \
            thunar gvfs-bin gvfs-backends thunar-archive-plugin file-roller tumbler
        ;;
    pacman)
        sudo pacman -S \
            thunar gvfs-smb gvfs-mtp thunar-archive-plugin file-roller tumbler
        ;;
esac

# symlink configuration
lnsf $DIR/Thunar/uca.xml ~/.config/Thunar/uca.xml