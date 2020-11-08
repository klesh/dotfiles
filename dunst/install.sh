#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

# install nvim
case "$PM" in
    apt)
        sudo apt install -y dunst
        ;;
    pacman)
        sudo pacman -S --needed dunst
        ;;
esac

# symlink configuration
lnsf "$DIR/content/dunstrc" "$XDG_CONFIG_HOME/dunst/dunstrc"
sudo cp -f "$DIR/content/dunstdaemon" "$PREFIX/bin"
sudo chmod +x "$PREFIX/bin/dunstdaemon"
