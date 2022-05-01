#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up mirror list'

if ! in_china; then
    echo 'Skip mirrors configuration'
    return
fi

# setup package mirror for CHINA
case "$PM" in
    apt)
        # backup original sources.list
        if [ ! -f /etc/apt/sources.list.bak ]; then
            sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
        fi
        # replace with aliyun mirror
        awk '$0 ~ /^deb/ {$2="https://mirrors.aliyun.com/ubuntu/"; print}' /etc/apt/sources.list.bak \
            | sudo tee /etc/apt/sources.list
        ;;
    pacman)
        COUNTRY=China
        if [ ! -f /etc/pacman.d/mirrorlist.bak ]; then
            sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
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
        ' /etc/pacman.d/mirrorlist.bak | sudo tee /etc/pacman.d/mirrorlist >/dev/null
        ;;
    xbps)
        mkdir -p /etc/xbps.d
        cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d/
        sed -i 's|https://alpha.de.repo.voidlinux.org|https://mirrors.tuna.tsinghua.edu.cn/voidlinux|g' /etc/xbps.d/*-repository-*.conf
esac


