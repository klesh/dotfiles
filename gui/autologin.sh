#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

echo 'Please enter autologin username (empty to skip): '
read -r LOGIN
if [ -z "$LOGIN" ]; then
    echo skip autologin setup
    return
fi

case "$UNAMEA" in
    *Ubuntu*)
        sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
        echo "
        [Service]
        ExecStart=
        ExecStart=-/sbin/agetty --autologin $LOGIN --noclear %I \$TERM
        " | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf > /dev/null
        ;;
    *artix*)
        sudo sed -i 's/"--noclear"/"--noclear --autologin '$LOGIN'"'
        ;;
esace
