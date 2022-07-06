#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up vim'

# check dependencies
#if [ "$VIM_MODE" = "enhanced" ]; then
    #if ! has_cmd node; then
        #"$PDIR/devel/nodejs.sh"
    #fi
    #if ! has_cmd python; then
        #"$PDIR/devel/python.sh"
    #fi
#fi

# install vim
export VIM=vim
case "$PM" in
    apt)
        # nvim not very compatible with CJK characters and ranger
        #sudo add-apt-repository ppa:neovim-ppa/stable -y
        #sudo apt update
        #sudo apt install -y neovim
        #if enhance_vim; then
            #sudo pip3 install pyvim neovim
        #fi

        # gui-common is required for clipboard integration
        sudo add-apt-repository ppa:jonathonf/vim -y -n
        pm_update
        sudo apt install -y vim vim-gui-common
        if enhance_vim; then
            sudo pip3 install pyvim
        fi
        ;;
    pacman)
        #sudo pacman -S --noconfirm --needed neovim ripgrep
        #git clone --depth 1 https://github.com/wbthomason/packer.nvim \
         #~/.local/share/nvim/site/pack/packer/start/packer.nvim
        #if enhance_vim; then
            #sudo pip install pyvim neovim
        #fi
        sudo pacman -S --noconfirm --needed nodejs npm yarn vim
        #if enhance_vim; then
            #$PDIR/devel/nodejs.sh config
            #sudo pip install pyvim
        #fi
        ;;
esac

# symlink configuration
#sudo ln -sf "$(command -v vim)" /usr/bin/v
lnsf "$DIR/vim/neovim/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"
lnsf "$DIR/vim/neovim/lua" "$XDG_CONFIG_HOME/nvim/lua"
lnsf "$DIR/vim/vim/vimrc" "$HOME/.vimrc"
lnsf "$DIR/vim/coc-settings.json" "$XDG_CONFIG_HOME/nvim/coc-settings.json"
lnsf "$DIR/vim/coc-settings.json" "$HOME/.vim/coc-settings.json"
