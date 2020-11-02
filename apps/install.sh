#!/bin/sh

DIR=$(readlink -f "$(dirname "$0")")
. "$DIR/../env.sh"


# install office utilities
case "$PM" in
    apt)
        sudo apt install -y \
            google-chrome-stable \
            zathura zathura-pdf-poppler sxiv \
            flameshot \
            gimp
        # libreoffice
        sudo add-apt-repository -y ppa:libreoffice/libreoffice-7-0
        sudo apt-get update
            libreoffice \
        ;;
    pacman)
        sudo pacman -S --needed \
            chromium \
            zathura zathura-pdf-mupdf sxiv\
            flameshot \
            libreoffice-fresh \
            gimp
        ;;
esac

# symlink configuration
lnsf "$DIR/config/zathura/zathurarc" "$XDG_CONFIG_HOME/zathura/zathurarc"
