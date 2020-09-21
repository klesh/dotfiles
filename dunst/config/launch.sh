#!/bin/bash

DIR=$(readlink -f $(dirname $0))

killall -q dunst
while pgrep -x dunst >/dev/null; do sleep 1; done
dunst -config $DIR/dunstrc &
