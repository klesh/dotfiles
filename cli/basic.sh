#!/bin/sh

set -e

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log "Installing basic utilities"
case "$PM" in
    apt)
        sudo apt install \
            build-essential \
            unzip p7zip \
            openssh-client \
            curl wget \
            man sudo
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed \
            base-devel \
            unzip p7zip \
            openssh \
            curl wget \
            man sudo
        # install yay
        if ! command -v yay >/dev/null; then
            intorepo https://aur.archlinux.org/yay.git /tmp/yay
            makepkg -si
            exitrepo
        fi
        ;;
esac

