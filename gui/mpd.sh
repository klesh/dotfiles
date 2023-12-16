#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up player: mpd'

# install music and video player
case "$PM" in
    apt)
        sudo apt install -y mpd mpc ncmpcpp
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed mpd mpc ncmpcpp
        ;;
    xbps)
        sudo xbps-install -y mpd mpc ncmpcpp
        ;;
esac

# symlink configuration
lnsf "$DIR/mpd/mpd.conf" "$XDG_CONFIG_HOME/mpd/mpd.conf"
lnsf "$DIR/ncmpcpp/bindings" "$XDG_CONFIG_HOME/ncmpcpp/bindings"
lnsf "$DIR/ncmpcpp/config" "$XDG_CONFIG_HOME/ncmpcpp/config"

# prevent system-wide mpd
if has_cmd systemctl; then
    sudo systemctl disable mpd
    sudo systemctl stop mpd
    # enable for current user
    systemctl --user enable mpd
    systemctl --user start mpd
fi
mkdir -p "$HOME/.mpd/playlists"


# command to update your database: mpc update
