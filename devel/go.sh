#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log "Setting up go"
# install go

if ! has_cmd go; then
case "$PM" in
    pkg)
        pkg install golang -y
        ;;
    apt)
        sudo apt install -y \
            golang
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed \
            go
        ;;
esac
fi

if in_china; then
    go env -w GO111MODULE=on
    go env -w GOPROXY=https://goproxy.io,direct
fi

# coc.nvim
if enhance_vim; then
    v -c "CocInstall -sync coc-go|qall"
fi

# air for autoreload webapp
echo Download air for autoreload webapp
echo https://github.com/cosmtrek/air/releases/latest
echo and store to ~/go/bin

