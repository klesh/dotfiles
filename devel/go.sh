#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log "Setting up go"
# install go
case "$PM" in
    apt)
        sudo apt install -y \
            golang
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed \
            go
        ;;
esac

if in_china; then
    go env -w GO111MODULE=on
    go env -w GOPROXY=https://goproxy.io,direct
fi

# coc.nvim
if enhance_vim; then
    v -c "CocInstall -sync coc-go|qall"
fi
