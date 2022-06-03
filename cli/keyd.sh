#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up keyd'

# setup package mirror for CHINA
case "$UNAMEA" in
    *Ubuntu*)
        ;;
    *artix*)
        yay -S keyd
        sudo mkdir /etc/runit/sv/keyd/
        sudo cp "$DIR/keyd/run" /etc/runit/sv/keyd/
        sudo ln -s /etc/runit/sv/keyd/ /run/runit/service/
        ;;
esac

# configuration
sudo cp "$DIR/keyd/default.conf" /etc/keyd/default.conf
