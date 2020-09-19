#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install ranger
case "$PM" in
    apt)
        sudo apt install -y \
            thunar gvfs-bin gvfs-backends thunar-archive-plugin file-roller tumbler
        ;;
    pacman)
        sudo pacman -S --needed \
            thunar gvfs-smb gvfs-mtp thunar-archive-plugin file-roller tumbler
        ;;
esac

# symlink configuration
lnsf $DIR/Thunar/uca.xml $XDG_CONFIG_HOME/Thunar/uca.xml
