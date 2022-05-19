#!/bin/sh

if mpc status | grep -F '[playing]'; then
    mpc pause
    RESTORE=1
fi
if [ -n "$LOCKER" ]; then
    $LOCKER
else
    slock
fi
if [ "$RESTORE" = 1 ]; then
    mpc play
fi
