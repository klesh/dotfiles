#!/bin/sh

DIR=$(readlink -f "$(dirname "$0")")
. "$DIR/../env.sh"

# check dependencies
! command -v yarnpkg && "$ROOT/nodejs/install.sh"

# install nvim
case "$PM" in
    apt)
        sudo add-apt-repository ppa:neovim-ppa/stable -y
        sudo apt update
        sudo apt install -y neovim
        ;;
    pacman)
        sudo pacman -S --needed neovim
        ;;
esac

# symlink configuration
lnsf "$DIR/config/init.vim" "$XDG_CONFIG_HOME/nvim/init.vim"
lnsf "$DIR/config/coc-settings.json" "$XDG_CONFIG_HOME/nvim/coc-settings.json"
lnsf "$DIR/config/init.vim" ~/.vimrc
