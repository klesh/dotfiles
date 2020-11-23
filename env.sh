#!/bin/sh

set -e
[ "$ENVSHED" = "yes" ] && return
ENVSHED=yes
PM=n/a
XDG_CONFIG_HOME=${XDG_CONFIG_HOME-"$HOME/.config"}
PREFIX=/usr/local
PDIR=$(dirname "${DIR-$0}")
GITHUB_PROXY=${GITHUB_PROXY-$HTTPS_PROXY}

in_china() {
    if [ -z "$IS_CHINA" ]; then
        IS_CHINA=no
        if curl -s myip.ipip.net | grep -qF '中国' > /dev/null; then
            IS_CHINA=yes
        fi
    fi
    [ "$IS_CHINA" = "no" ] && echo "in_china: no" && return 1
    echo "in_china: yes"
    return 0
}

lnsf() {
    [ "$#" -ne 2 ] && echo "lnsf <target> <symlink>" && return 1
    TARGET=$(readlink -f "$1") || (echo failed: readlink -f "$1" ; return 1)
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

has_bluetooth() {
    dmesg | grep -i bluetooth
}

eqv() {
    VERSION_PATH=$1
    VERSION=$2
    [ ! -f "$VERSION_PATH" ] && return 1
    VERSION2="$(cat "$VERSION_PATH")"
    [ "$VERSION" = "$VERSION2" ]
}

git_clone() {
    mkdir -p "$(dirname "$2")"
    [ -d "$2" ] && return
    if echo "$1" | grep -qF 'github.com'; then
        HTTPS_PROXY=$GITHUB_PROXY git clone --depth 1 "$1" "$2"
    else
        git clone --depth 1 "$1" "$2"
    fi
}

intorepo() {
    ODIR=$(pwd)
    REPO=$2
    git_clone "$1" "$REPO"
    cd "$REPO"
}

exitrepo() {
    cd "$ODIR"
}

log() {
    printf "\n\033[32m%s\033[0m\n" "$@"
}

has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

has_fish() {
    has_cmd "$1"
}


sudo mkdir -p $PREFIX

if has_cmd pacman; then
    PM=pacman
elif has_cmd apt; then
    PM=apt
fi

if [ "$PM" = "n/a" ]; then
    echo "Unsupported Package Manager"
    exit 1
fi

log "Installing basic utilities"
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
        sudo pacman -S --noconfirm --needed \
            base-devel \
            unzip p7zip \
            openssh \
            curl wget \
            man sudo
        # install yay
        if ! command -v yay >/dev/null; then
            intorepo https://aur.archlinux.org/yay.git /tmp/yay
            makepkg -si
            exitrepo
        fi
        ;;
esac


log "Environments"
echo " PM           : $PM"
echo " DIR          : $DIR"
echo " PDIR         : $PDIR"
echo " PREFIX       : $PREFIX"
echo " GITHUB_PROXY : $GITHUB_PROXY"
