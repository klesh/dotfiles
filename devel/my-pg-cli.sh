#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"
"$PDIR/devel/python.sh"

# install mycli and pgcli
case "$PM" in
    pkg)
        echo todo
        exit -1
        ;;
    apt)
        sudo apt install -y libpq-dev
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed postgresql-libs
        ;;
esac

sudo pip install mycli
sudo pip install pgcli
