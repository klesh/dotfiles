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
lnsf $DIR/config/mpd/mpd.conf $XDG_CONFIG_HOME/mpd/mpd.conf
lnsf $DIR/config/mpv/mpv.conf $XDG_CONFIG_HOME/mpv/mpv.conf
lnsf $DIR/config/mpv/scripts/organize.lua $XDG_CONFIG_HOME/mpv/scripts/organize.lua
lnsf $DIR/config/ncmpcpp/bindings $XDG_CONFIG_HOME/ncmpcpp/bindings
lnsf $DIR/config/ncmpcpp/config $XDG_CONFIG_HOME/ncmpcpp/config

# prevent system-wide mpd
sudo systemctl disable mpd
sudo systemctl stop mpd
mkdir -p $HOME/.mpd/playlists

# enable for current user
systemctl --user enable mpd
systemctl --user start mpd
