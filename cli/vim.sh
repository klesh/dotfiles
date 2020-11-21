#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up vim'

# check dependencies
if [ "$VIM_MODE" = "enhanced" ]; then
    ! has_cmd npm && "$PDIR/devel/nodejs.sh"
    ! has_cmd pip && "$PDIR/devel/python.sh"
fi

# install nvim
case "$PM" in
    apt)
        sudo add-apt-repository ppa:neovim-ppa/stable -y
        sudo apt update
        sudo apt install -y neovim
        [ "$VIM_MODE" = "enhanced" ] && sudo pip3 install pyvim neovim
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed neovim
        [ "$VIM_MODE" = "enhanced" ] && sudo pip install pyvim neovim
        ;;
esac

# symlink configuration
lnsf "$DIR/vim/init.vim" "$XDG_CONFIG_HOME/nvim/init.vim"
lnsf "$DIR/vim/coc-settings.json" "$XDG_CONFIG_HOME/nvim/coc-settings.json"
lnsf "$DIR/vim/coc-settings.json" "$HOME/.vim/coc-settings.json"
lnsf "$DIR/vim/init.vim" "$HOME/.vimrc"
