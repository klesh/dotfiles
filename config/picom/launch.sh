#!/usr/bin/env sh

killall -q picom
while pgrep -x picom >/dev/null; do sleep 1; done
picom -b --config ~/.config/picom/picom.conf
