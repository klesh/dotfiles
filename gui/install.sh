#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

if [ "$PM" = "apt" ]; then
    sudo systemctl disable systemd-networkd-wait-online
    sudo systemctl mask systemd-networkd-wait-online
    sudo systemctl disable cloud-init
    sudo systemctl mask cloud-init
    sudo systemctl disable cloud-config
    sudo systemctl mask cloud-config
    sudo systemctl disable gdm3
    sudo systemctl mask gdm3
fi

. "$DIR/autologin.sh"
. "$DIR/suspendlock.sh"
. "$DIR/font.sh"
. "$DIR/sysutils.sh"
. "$DIR/picom.sh"
. "$DIR/office.sh"
. "$DIR/player.sh"
. "$DIR/theme.sh"
. "$DIR/suckless.sh"
