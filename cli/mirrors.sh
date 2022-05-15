#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up mirror list'

if ! in_china; then
    echo 'Skip mirrors configuration'
    return
fi


pacman_china_mirror() {
    MIRRORLIST=${1:-/etc/pacman.d/mirrorlist}
    MIRRORLIST_BAK=$MIRRORLIST.bak
    COUNTRY=${2:-China}
    if [ ! -f "$MIRRORLIST_BAK" ]; then
        sudo cp "$MIRRORLIST" "$MIRRORLIST_BAK"
    fi
    awk '
    {
        if (NR < 7) {
            print
        } else if ($0 == "## '$COUNTRY'") {
            print
            matched = 1
        } else if (matched == 1) {
            print
            matched = 0
        } else {
            buffer = buffer "\n" $0
        }
    }
    END { print buffer }
    ' "$MIRRORLIST_BAK" | sudo tee "$MIRRORLIST"  >/dev/null
}


# setup package mirror for CHINA
case "$UNAMEA" in
    *Ubuntu*)
        # backup original sources.list
        if [ ! -f /etc/apt/sources.list.bak ]; then
            sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
        fi
        # replace with aliyun mirror
        awk '$0 ~ /^deb/ {$2="https://mirrors.aliyun.com/ubuntu/"; print}' /etc/apt/sources.list.bak \
            | sudo tee /etc/apt/sources.list
        ;;
    *artix*)
        # enable arch repo
        sudo pacman -S --needed --noconfirm artix-archlinux-support
        if ! grep -qF "mirrorlist-arch" /etc/pacman.conf; then
            echo "# Arch" >> sudo tee -a /etc/pacman
            echo "[extra]" >> sudo tee -a /etc/pacman
            echo "Include = /etc/pacman.d/mirrorlist-arch" >> sudo tee -a /etc/pacman
            echo "" >> sudo tee -a /etc/pacman
            echo "[community]" >> sudo tee -a /etc/pacman
            echo "Include = /etc/pacman.d/mirrorlist-arch" >> sudo tee -a /etc/pacman
            echo "" >> sudo tee -a /etc/pacman
            echo "[multilib]" >> sudo tee -a /etc/pacman
            echo "Include = /etc/pacman.d/mirrorlist-arch" >> sudo tee -a /etc/pacman
        fi
        ;;
        pacman_china_mirror /etc/pacman.d/mirrorlist Asia
        pacman_china_mirror /etc/pacman.d/mirrorlist-arch
        sudo pacman -Sy
esac
