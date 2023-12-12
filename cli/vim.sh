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
case "$UNAMEA" in
    *Ubuntu*)
        # gui-common is required for clipboard integration
        # sudo add-apt-repository ppa:jonathonf/vim -y -n
        # pm_update
        # sudo apt install -y vim vim-gui-common
        # if enhance_vim; then
        #     sudo pip3 install pyvim
        # fi
        sudo add-apt-repository ppa:neovim-ppa/stable
        sudo apt-get update
        sudo apt-get install neovim ripgrep
        ;;
    *Debian*)
	sudo apt install vim
        ;;
    *arch*)
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

#git clone --depth 1 https://github.com/wbthomason/packer.nvim\
# ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo "For lua"
echo Download archive from  https://github.com/sumneko/lua-language-server/releases and extract the 'lua-language-server' and setup the PATH accordingly
echo
echo "For c/c++"
echo "Insall the 'clang'(language server) and 'bear'(generate compile_commands.json from make command)"

# symlink configuration
#sudo ln -sf "$(command -v vim)" /usr/bin/v
#lnsf "$DIR/vim/neovim/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"
#lnsf "$DIR/vim/neovim/lua" "$XDG_CONFIG_HOME/nvim/lua"
lnsf "$DIR/vim/vim/vimrc" "$HOME/.vimrc"
#lnsf "$DIR/vim/coc-settings.json" "$XDG_CONFIG_HOME/nvim/coc-settings.json"
#lnsf "$DIR/vim/coc-settings.json" "$HOME/.vim/coc-settings.json"
