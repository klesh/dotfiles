#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up nnn'

# setup package mirror for CHINA
case "$PM" in
    apt)
        echo TODO
        exit -1
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed nnn
        yay -S --noconfirm --needed dragon-drag-and-drop
esac

# configuration
lnsf "$DIR/nnn/n.fish" "$XDG_CONFIG_HOME/fish/functions/n.fish"
cp -r /usr/share/nnn/plugins/. "$XDG_CONFIG_HOME/nnn/plugins"
