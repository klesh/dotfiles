#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Settingup office tools: libreoffice keepassxc nextcloud chrome zathura gimp sxiv typora'

case "$PM" in
    apt)
        sudo add-apt-repository -y -n ppa:libreoffice/libreoffice-7-0
        sudo add-apt-repository -y -n ppa:phoerious/keepassxc
        sudo add-apt-repository -y -n ppa:nextcloud-devs/client
        pm_update
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
        yay -S typora
        ;;
esac

lnsf "$DIR/zathura/zathurarc" "$XDG_CONFIG_HOME/zathura/zathurarc"
rm -f "$HOME/.local/share/applications/chrome-*.desktop"
xdg-mime default org.pwmt.zathura.desktop application/pdf
