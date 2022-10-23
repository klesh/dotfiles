#!/bin/sh


screenoff(){
    sleep 3
    xset dpms force off
}

if mpc status | grep -F '[playing]'; then
    mpc pause
    RESTORE_MPD=1
fi
if command -v bluetoothctl >/dev/null; then
    RESTORE_BLU=$(bluetoothctl show | grep -F "Powered: yes")
fi
if [ -n "$LOCKER" ]; then
    screenoff &
    $LOCKER
else
    slock
fi
if [ "$RESTORE_MPD" = 1 ]; then
    mpc play
fi
if [ -n "$RESTORE_BLU" ]; then
    bluetoothctl power on
fi
