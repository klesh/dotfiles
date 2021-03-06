#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up vim'

# check dependencies
if [ "$VIM_MODE" = "enhanced" ]; then
    if ! has_cmd node; then
        "$PDIR/devel/nodejs.sh"
    fi
    if ! has_cmd python; then
        "$PDIR/devel/python.sh"
    fi
fi

# install nvim
if ! has_cmd "$VIM"; then
    case "$PM" in
        apt)
            sudo add-apt-repository ppa:neovim-ppa/stable -y
            sudo apt update
            sudo apt install -y neovim
            if enhance_vim; then
                sudo pip3 install pyvim neovim
            fi
            ;;
        pacman)
            sudo pacman -S --noconfirm --needed neovim
            if enhance_vim; then
                sudo pip install pyvim neovim
            fi
            ;;
    esac
fi

# symlink configuration
sudo ln -sf "$(command -v nvim)" /usr/bin/v
lnsf "$DIR/vim/init.vim" "$XDG_CONFIG_HOME/nvim/init.vim"
lnsf "$DIR/vim/coc-settings.json" "$XDG_CONFIG_HOME/nvim/coc-settings.json"
lnsf "$DIR/vim/coc-settings.json" "$HOME/.vim/coc-settings.json"
lnsf "$DIR/vim/init.vim" "$HOME/.vimrc"
