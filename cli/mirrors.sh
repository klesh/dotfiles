#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up mirror list'

! in_china && echo 'Skip mirrors configuration' && return

# setup package mirror for CHINA
case "$PM" in
    apt)
        # backup original sources.list
        [ ! -f /etc/apt/sources.list.bak ] && \
            sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
        # replace with aliyun mirror
        awk '$0 ~ /^deb/ {$2="https://mirrors.aliyun.com/ubuntu/"; print}' /etc/apt/sources.list.bak \
            | sudo tee /etc/apt/sources.list
        ;;
    pacman)
        COUNTRY=China
        [ ! -f /etc/pacman.d/mirrorlist.bak ] && \
            sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
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
esac


