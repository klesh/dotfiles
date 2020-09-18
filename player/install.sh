#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh


# install music and video player
case "$PM" in
    apt)
        sudo apt install -y mpd mpc ncmpcpp mpv
        ;;
    pacman)
        sudo pacman -S mpd mpc ncmpcpp mpv
        ;;
esac

# symlink configuration
lnsf $DIR/config/mpd ~/.config/mpd
lnsf $DIR/config/ncmpcpp ~/.config/ncmpcpp
lnsf $DIR/config/mpv ~/.config/mpv