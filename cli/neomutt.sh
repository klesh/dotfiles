#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up neomutt'

case "$PM" in
    pacman)
        sudo pacman -S --noconfirm --needed neomutt isync lynx notmuch cronie urlscan
        yay -S --noconfirm --needed abook cyrus-sasl-xoauth2-git
        ;;
esac


case "$UNAMEA" in
    *artix*)
        sudo pacman -S --noconfirm --needed cronie-runit
        sudo ln -sf /etc/runit/sv/cronie/ /run/runit/service/
        ;;
esac


makeinstallrepo https://github.com/klesh/mutt-wizard.git mutt-wizard
