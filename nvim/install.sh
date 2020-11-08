#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

# check dependencies
! command -v yarnpkg && "$PDIR/nodejs/install.sh"
! command -v pip && "$PDIR/python/install.sh"

# install nvim
case "$PM" in
    apt)
        sudo add-apt-repository ppa:neovim-ppa/stable -y
        sudo apt update
        sudo apt install -y neovim
        sudo pip3 install pyvim neovim
        ;;
    pacman)
        sudo pacman -S --needed neovim
        sudo pip install pyvim neovim
        ;;
esac

# symlink configuration
lnsf "$DIR/config/init.vim" "$XDG_CONFIG_HOME/nvim/init.vim"
lnsf "$DIR/config/coc-settings.json" "$XDG_CONFIG_HOME/nvim/coc-settings.json"
lnsf "$DIR/config/init.vim" ~/.vimrc
lnsf "$DIR/config/coc-settings.json" ~/.vim/coc-settings.json
