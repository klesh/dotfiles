#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up nnn'

NNN_CONFIG_DIR="$XDG_CONFIG_HOME/nnn"

download_nnn_plugins() {
    mkdir -p "$NNN_CONFIG_DIR/plugins"
    echo dowhload fzcd
    HTTPS_PROXY=$GITHUB_PROXY curl -Lo  "$NNN_CONFIG_DIR/plugins/fzcd" https://github.com/jarun/nnn/raw/master/plugins/fzcd
    echo download preview-tui
    HTTPS_PROXY=$GITHUB_PROXY curl -Lo  "$NNN_CONFIG_DIR/plugins/preview-tui" https://github.com/jarun/nnn/raw/master/plugins/preview-tui
    echo download dragdrop
    HTTPS_PROXY=$GITHUB_PROXY curl -Lo  "$NNN_CONFIG_DIR/plugins/dragdrop" https://github.com/jarun/nnn/raw/master/plugins/dragdrop
    chmod +x $NNN_CONFIG_DIR/plugins/*
}

case "$PM" in
    apt)
        if ! has_cmd nnn; then
            mkdir -p ~/.local/bin
            HTTPS_PROXY=$GITHUB_PROXY curl -Lo /tmp/nnn.tar.gz https://github.com/jarun/nnn/releases/download/v4.3/nnn-static-4.3.x86_64.tar.gz
            cd /tmp
            tar zxvf nnn.tar.gz
            mv nnn-static ~/.local/bin/nnn
            rm -rf nnn.tar.gz
            cd -
        fi
        download_nnn_plugins
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed nnn ueberzug
        mkdir -p "$NNN_CONFIG_DIR/plugins"
        cp -r /usr/share/nnn/plugins/* "$NNN_CONFIG_DIR/plugins"
        yay -S dragon-drop
        ;;
esac

# configuration
lnsf "$DIR/nnn/n.fish" "$XDG_CONFIG_HOME/fish/functions/n.fish"
