#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up syncthing'

case "$UNAMEA" in
    *Ubuntu*)
        sudo apt install -y \
            syncthing
        ;;
    *artix*)
        sudo pacman -S --noconfirm --needed \
            syncthing
        ;;
esac


echo "export LOCKER=i3lock"
