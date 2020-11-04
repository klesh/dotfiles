#!/bin/sh

set -e
ROOT=$(readlink -f "$(dirname "$0")")
PM=n/a
XDG_CONFIG_HOME=${XDG_CONFIG_HOME-"$HOME/.config"}
echo "dotfiles path: $ROOT"

if command -v pacman > /dev/null; then
    PM=pacman
elif command -v apt > /dev/null; then
    PM=apt
fi

if [ "$PM" = "n/a" ]; then
    echo "Unsupported Package Manager"
    exit 1
fi

in_china () {
    if [ -z "$IS_CHINA" ]; then
        IS_CHINA=no
        if curl -q myip.ipip.net | grep '中国' > /dev/null; then
            IS_CHINA=yes
        fi
    fi
    [ "$IS_CHINA" = "no" ] && return 1
    return 0
}

lnsf () {
    [ "$#" -ne 2 ] && echo "lnsf <target> <symlink>" && return 1
    TARGET=$(readlink -f "$1")
    SYMLNK=$2
    [ -z "$TARGET" ] && echo "$1 not exists" && return 1
    SYMDIR=$(dirname "$SYMLNK")
    if [ -n "$SYMDIR" ] && [ -L "$SYMDIR" ]; then
        rm -rf "$SYMDIR"
    fi
    mkdir -p "$SYMDIR"
    [ ! -L "$SYMLNK" ] && rm -rf "$SYMLNK"
    ln -sf "$TARGET" "$SYMLNK"
}

has_bluetooth () {
    dmesg | grep -i bluetooth
}

eqv () {
    VERSION_PATH=$1
    VERSION=$2
    [ ! -f "$VERSION_PATH" ] && return 1
    VERSION2="$(cat "$VERSION_PATH")"
    [ "$VERSION" = "$VERSION2" ]
}


# install basic common utilities
case "$PM" in
    apt)
        sudo apt install \
            build-essential \
            unzip p7zip \
            openssh-client \
            curl wget \
            man sudo
        ;;
    pacman)
        sudo pacman -S --needed --needed \
            base-devel \
            unzip p7zip \
            openssh \
            curl wget \
            man sudo
        # install yay
        if ! command -v yay; then
            git clone --depth 1 https://aur.archlinux.org/yay.git /tmp/yay
            cd /tmp/yay
            makepkg -si
            cd -
        fi
        ;;
esac

