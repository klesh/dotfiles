#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Settingup office tools: libreoffice keepassxc nextcloud chrome zathura gimp sxiv'

case "$PM" in
    apt)
        sudo add-apt-repository -y ppa:libreoffice/libreoffice-7-0
        sudo add-apt-repository -y ppa:phoerious/keepassxc
        sudo add-apt-repository -y ppa:nextcloud-devs/client
        sudo apt update
        sudo apt install -y \
            google-chrome-stable \
            zathura zathura-pdf-poppler sxiv \
            gimp \
            libreoffice \
            keepassxc \
            nextcloud-client
        ;;
    pacman)
        # fonts
        sudo pacman -S --noconfirm --needed \
            chromium \
            zathura zathura-pdf-mupdf sxiv \
            gimp \
            libreoffice-fresh \
            keepassxc \
            nextcloud-client
        ;;
esac

lnsf "$DIR/zathura/zathurarc" "$XDG_CONFIG_HOME/zathura/zathurarc"
rm -f "$HOME/.local/share/applications/chrome-*.desktop"
