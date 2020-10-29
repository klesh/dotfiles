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
        if apt show fzf &>/dev/null; then
            sudo apt install fzf
        else
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install
        fi
        ;;
    pacman)
        ! which pip && $ROOT/python/install.sh
        sudo pacman -S --needed --needed fish xdotool fzf
        ;;
esac

# set fish as default shell
if ! fish-is-default-shell; then
    chsh -s $FISH_SHELL
fi

# symlink config
[ -L $XDG_CONFIG_HOME/fish ] && rm -rf $XDG_CONFIG_HOME/fish

lnsf $DIR/config/config.fish $XDG_CONFIG_HOME/fish/config.fish
lnsf $DIR/config/functions/fish_prompt.fish $XDG_CONFIG_HOME/fish/functions/fish_prompt.fish
lnsf $DIR/config/functions/fish_right_prompt.fish $XDG_CONFIG_HOME/fish/functions/fish_right_prompt.fish
lnsf $DIR/config/functions/fisher.fish $XDG_CONFIG_HOME/fish/functions/fisher.fish

# install plugins
fish -c "fisher add jethrokuan/fzf"

