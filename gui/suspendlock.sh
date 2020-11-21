#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up lock on suspend'

echo "
[Unit]
Description=Lock on suspend
Before=sleep.target

[Service]
ExecStart=/usr/bin/loginctl lock-sessions
ExecStartPost=/usr/bin/sleep 2

[Install]
WantedBy=sleep.target
" | sudo tee /etc/systemd/system/suspendlock.service >/dev/null

sudo systemctl enable suspendlock
