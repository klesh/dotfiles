#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up shell'

case "$UNAMEA" in
    *artix*)
        sudo pacman -S --noconfirm --needed clash
        sudo rm -rf /etc/runit/sv/clash
        sudo cp -r $DIR/prx /etc/runit/sv/clash
        sudo mkdir -p /etc/clash
        sudo cp ~/Nextcloud/docker/clash/config.yaml /etc/clash/
        sudo cp ~/Nextcloud/docker/clash/Country.mmdb /etc/clash/
        sudo rm -rf /etc/clash/ui
        sudo cp -r ~/Nextcloud/docker/clash/clash-dashboard-gh-pages /etc/clash/ui
        sudo ln -sf /etc/runit/sv/clash/ /run/runit/service/
        #wget https://cdn.jsdelivr.net/gh/alecthw/mmdb_china_ip_list@release/Country.mmdb -O ~/.config/clash/Country.mmdb
        ;;
esac
