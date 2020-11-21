#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up player: mpv mpd'

# install music and video player
case "$PM" in
    apt)
        sudo apt install -y mpd mpc ncmpcpp mpv
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed mpd mpc ncmpcpp mpv
        ;;
esac

# symlink configuration
lnsf "$DIR/mpd/mpd.conf" "$XDG_CONFIG_HOME/mpd/mpd.conf"
lnsf "$DIR/mpv/mpv.conf" "$XDG_CONFIG_HOME/mpv/mpv.conf"
lnsf "$DIR/mpv/scripts/organize.lua" "$XDG_CONFIG_HOME/mpv/scripts/organize.lua"
lnsf "$DIR/ncmpcpp/bindings" "$XDG_CONFIG_HOME/ncmpcpp/bindings"
lnsf "$DIR/ncmpcpp/config" "$XDG_CONFIG_HOME/ncmpcpp/config"

# prevent system-wide mpd
sudo systemctl disable mpd
sudo systemctl stop mpd
mkdir -p "$HOME/.mpd/playlists"

# enable for current user
systemctl --user enable mpd
systemctl --user start mpd
