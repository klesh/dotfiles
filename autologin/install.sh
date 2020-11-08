#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

echo 'Please enter autologin username (empty to skip): '
read -r username
if [  -z "$username" ]; then
    echo skip autologin setup
else
    sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
    sed -r "s/USERNAME/$username/g" "$DIR/systemd/getty1-override.conf" | \
        sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf
fi
