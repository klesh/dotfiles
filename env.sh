#!/bin/sh

set -e
[ "$ENVSHED" = "yes" ] && return
ENVSHED=yes
PM=n/a
XDG_CONFIG_HOME=${XDG_CONFIG_HOME-"$HOME/.config"}
PREFIX=/usr/local
PDIR=$(dirname "${DIR-$0}")
GITHUB_PROXY=${GITHUB_PROXY-$HTTPS_PROXY}
WSL=$(grep -i Microsoft /proc/sys/kernel/osrelease || true)
TMPDIR=${TMPDIR-"/tmp"}
UNAMEA=$(uname -a)
RUNIT=$(command -v runit || true)

if [ -f /etc/os-release ]; then
    . /etc/os-release
elif uname -a | grep artix; then
    ID=artix
fi

in_china() {
    if ! [ -f $TMPDIR/myip_full ] || ! [ -s $TMPDIR/myip_full ]; then
        curl -s myip.ipip.net > $TMPDIR/myip_full
    fi
    grep -qF '中国' $TMPDIR/myip_full >/dev/null
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
    has_cmd sudo && sudo dmesg | grep -i bluetooth
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
        HTTPS_PROXY=$GITHUB_PROXY git clone --depth 1 "$@"
    else
        git clone --depth 1 "$@"
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


makeinstallrepo () {
    intorepo "$1" "$DIR/repos/$2"
    make && sudo make install
    exitrepo
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

is_laptop() {
    [ -f /sys/class/power_supply/BAT0/capacity ]
}

enhance_vim() {
    [ "$VIM_MODE" = "enhanced" ] && has_cmd nvim
}

pm_update() {
    # skip updation on daily basis
    TSFILE=/tmp/apt_updated_at_$(date +%Y%m%d)
    CHECKSUM=$(md5sum /etc/apt/sources.list /etc/apt/sources.list.d/*.list | sort | md5sum)
    grep -qF "$CHECKSUM" "$TSFILE" && return
    case "$PM" in
        apt)
            sudo apt update
            ;;
        *)
            echo "unsupported os"
            exit 1
            ;;
    esac
    echo "$CHECKSUM" > "$TSFILE"
}

win_env_path() {
    cmd.exe /c 'echo '$1 2>/dev/null | awk '{sub("C:", "/mnt/c"); gsub("\\\\","/"); print}'
}


has_cmd sudo && sudo mkdir -p $PREFIX

if has_cmd pacman; then
    PM=pacman
elif has_cmd pkg; then
    PM=pkg
    sudo () {
        "$@"
    }
elif has_cmd apt; then
    PM=apt
elif has_cmd xbps-install; then
    PM=xbps
fi

if [ "$PM" = "n/a" ]; then
    echo "Unsupported Package Manager"
    exit 1
fi
if [ -f /etc/lsb-release ]; then
    set -a
    . /etc/lsb-release
    set +a
    export DISTRIB_RELEASE_MAJOR=${DISTRIB_RELEASE%.*}
    export DISTRIB_RELEASE_MINOR=${DISTRIB_RELEASE#.*}
elif [ -f /etc/os-release ]; then
    set -a
    . /etc/os-release
    set +a
    export DISTRIB_ID=$ID
    export DISTRIB_RELEASE_MAJOR=$VERSION_ID
fi

log "Environments"
echo " PM           : $PM"
echo " DIR          : $DIR"
echo " PDIR         : $PDIR"
echo " PREFIX       : $PREFIX"
echo " GITHUB_PROXY : $GITHUB_PROXY"
