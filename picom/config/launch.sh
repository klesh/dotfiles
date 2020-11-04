#!/bin/sh

DIR=$(readlink -f $(dirname $0))

killall -q picom
while pgrep -x picom >/dev/null; do sleep 1; done
picom -b --config $DIR/picom.conf --experimental-backends \
    --blur-method dual_kawase --blur-strength 6 \
    --no-fading-openclose
sleep 1
! pgrep -x picom && picom -b --config $DIR/picom.conf --no-fading-openclose
