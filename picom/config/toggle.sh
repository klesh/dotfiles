#!/bin/bash

DIR=$(readlink -f $(dirname $0))

if pgrep -x picom > /dev/null; then
  killall -q picom
else
  $DIR/launch.sh
fi
