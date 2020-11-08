#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"


! in_china && echo 'Skip mirrors configuration' && exit

# setup package mirror for CHINA
case "$PM" in
    apt)
        # backup original sources.list
        [ ! -f /etc/apt/sources.list.bak ] && \
            sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
        # replace with aliyun mirror
        awk '$0 ~ /^deb/ {$2="https://mirrors.aliyun.com/ubuntu/"; print}' /etc/apt/sources.list.bak | sudo tee /etc/apt/sources.list
        sudo apt update
        ;;
    pacman)
        echo TODO
        exit 1
        ;;
esac


