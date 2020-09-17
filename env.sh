#!/bin/bash

set -e
ROOT=$(readlink -f $(dirname "${BASH_SOURCE[0]}"))
PM=n/a

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

ln-dir () {
    [ "$#" -ne 2 ] && echo "ln-dir <dir> <symlink>"
    [ ! -L "$2" ] && rm -rf $2
    SYM_DIR=$(dirname $2)
    [ -n "$SYM_DIR" ] && mkdir -p $SYM_DIR
    ln -sf $1 $2
}