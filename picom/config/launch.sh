#!/bin/bash

DIR=$(readlink -f $(dirname $0))

killall -q picom
while pgrep -x picom >/dev/null; do sleep 1; done
echo $DIR/picom.conf
picom -b --config $DIR/picom.conf
