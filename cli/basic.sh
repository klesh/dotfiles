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
        if [ -f /etc/lsb-release ]; then
            set -a
            . /etc/lsb-release
            set +a
            export DISTRIB_RELEASE_MAJOR=${DISTRIB_RELEASE%.*}
            export DISTRIB_RELEASE_MINOR=${DISTRIB_RELEASE#.*}
        fi
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
