#!/bin/bash

set -e
ROOT=$(readlink -f $(dirname "${BASH_SOURCE[0]}"))
PM=n/a
DEFAULT_SHELL=$(getent passwd $USER | cut -d: -f7)
FISH=$(which fish)
XDG_CONFIG_HOME=${XDG_CONFIG_HOME-"$HOME/.config"}

if which pacman > /dev/null; then
    PM=pacman
elif which apt > /dev/null; then
    PM=apt
fi

if [ "$PM" = "n/a" ]; then
    echo "Unsupported Package Manager"
    exit -1
fi

in-china () {
    if [ -z "$IS_CHINA" ]; then
        IS_CHINA=no
        if curl -q myip.ipip.net | grep '中国' > /dev/null; then
            IS_CHINA=yes
        fi
    fi
    [ "$IS_CHINA" = "no" ] && return -1
    return 0
}

lnsf () {
    [ "$#" -ne 2 ] && echo "lnsf <target> <symlink>" && return -1
    local TARGET=$(readlink -f $1)
    local SYMLNK=$2
    [ -z "$TARGET" ] && echo "$1 not exists" && return -1
    local SYMDIR=$(dirname $SYMLNK)
    if [[ -n $SYMDIR && -L $SYMDIR ]]; then
        rm -rf $SYMDIR
    fi
    mkdir -p $SYMDIR
    [ ! -L $SYMLNK ] && rm -rf $SYMLNK
    ln -sf $TARGET $SYMLNK
}

fish-is-default-shell () {
    [ "$DEFAULT_SHELL" = "$FISH" ]
}

has-bluetooth () {
    dmesg | grep -i bluetooth
}

eqv () {
    local VERSION_PATH=$1
    local VERSION=$2
    [ ! -f $VERSION_PATH ] && return -1
    local VERSION2=$(cat "$VERSION_PATH")
    [ "$VERSION" = "$VERSION2" ]
}


# install basic common utilities
case "$PM" in
    apt)
        sudo apt install \
            build-essential \
            unzip p7zip \
            openssh-server openssh-client \
            exfat-utils \
            axel \
            man sudo
        ;;
    pacman)
        sudo pacman -S --needed --needed \
            base-devel \
            unzip p7zip \
            openssh \
            exfat-utils \
            axel \
            man sudo
        ;;
esac

