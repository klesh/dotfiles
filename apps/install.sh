#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh


# install office utilities
case "$PM" in
    apt)
        sudo apt install -y \
            chromium-browser \
            zathura zathura-pdf-poppler sxiv \
            flameshot \
            libreoffice \
            gimp
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
lnsf $DIR/config/zathura ~/.config/zathura
