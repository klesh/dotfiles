#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up i3lock'

case "$UNAMEA" in
    *Ubuntu*)
        sudo apt install -y \
            xss-lock i3lock
        ;;
    *artix*)
        sudo pacman -S --noconfirm --needed \
            xss-lock i3lock
        ;;
esac


echo "export LOCKER=i3lock"
