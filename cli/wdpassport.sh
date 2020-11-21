#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"


# install WD Passport decryption
case "$PM" in
    apt)
        ;;
    pacman)
        sudo pacman -Sy python2-pip lsscsi
        sudo pip2 install py_sg
        ;;
esac

# download python script
PREFIX=~/.local/bin
mkdir -p $PREFIX
curl -L https://github.com/0-duke/wdpassport-utils/raw/master/wdpassport-utils.py \
    | sed 's/python/python2/' \
    > $PREFIX/wdpassport-utils
chmod +x $PREFIX/wdpassport-utils
