#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up player: mpv'

# install mpv
case "$PM" in
    apt)
        sudo apt install -y mpv
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed mpv
        ;;
    xbps)
        sudo xbps-install -y mpv
        ;;
esac

# symlink configuration
lnsf "$DIR/mpv/mpv.conf" "$XDG_CONFIG_HOME/mpv/mpv.conf"
lnsf "$DIR/mpv/input.conf" "$XDG_CONFIG_HOME/mpv/input.conf"
lnsf "$DIR/mpv/scripts/organize.lua" "$XDG_CONFIG_HOME/mpv/scripts/organize.lua"
lnsf "$DIR/mpv/scripts/cut.lua" "$XDG_CONFIG_HOME/mpv/scripts/cut.lua"

