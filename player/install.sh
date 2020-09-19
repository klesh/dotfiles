#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh


# install music and video player
case "$PM" in
    apt)
        sudo apt install -y mpd mpc ncmpcpp mpv
        ;;
    pacman)
        sudo pacman -S --needed mpd mpc ncmpcpp mpv
        ;;
esac

# symlink configuration
lnsf $DIR/config/mpd $XDG_CONFIG_HOME/mpd
lnsf $DIR/config/ncmpcpp $XDG_CONFIG_HOME/ncmpcpp
lnsf $DIR/config/mpv $XDG_CONFIG_HOME/mpv

# enable for current user
systemctl --user enable mpd
systemctl --user start mpd
