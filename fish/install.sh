#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install fish shell
echo Installing fish shell
case "$PM" in
    apt)
        ! which pip3 && $ROOT/python/install.sh
        sudo add-apt-repository ppa:fish-shell/release-3 -y
        sudo apt update
        sudo apt install fish libnotify-bin xdotool -y
        ;;
    pacman)
        ! which pip && $ROOT/python/install.sh
        sudo pacman -S fish xdotool
        ;;
esac

# set fish as default shell
if ! fish-is-default-shell; then
    chsh -s $FISH_SHELL
fi

# symlink config
[ -L ~/.config/fish ] && rm -rf ~/.config/fish

lnsf $DIR/config/config.fish ~/.config/fish/config.fish
lnsf $DIR/config/functions/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
lnsf $DIR/config/functions/fish_right_prompt.fish ~/.config/fish/functions/fish_right_prompt.fish
