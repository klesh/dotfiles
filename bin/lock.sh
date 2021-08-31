#!/bin/sh

if mpc status | grep -F '[playing]'; then
    mpc pause
    RESTORE=1
fi
slock
if [ "$RESTORE" = 1 ]; then
    mpc play
fi
