#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log "Setting up qmk"

if [ -z "$QMK_HOME" ]; then
    echo "warning: \$QMK_HOME is empty!\
                    if you already had qmk_firmware cloned, set it to \$QMK_HOME first \
                    press Ctrl-c to cancel the installation, Enter to continue"
    read -r
fi

if in_china && [ -z "$HTTPS_PROXY" ]; then
    echo "warning: \$HTTPS_PROXY is empty!\
                    cloning speed for submodules could be slow AF in china, are u sure? \
                    press Ctrl-c to cancel the installation, Enter to continue"
    read -r
fi

QMK_HOME=${QMK_HOME-"$HOME/qmk_firmware"}

case "$PM" in
    apt)
        sudo pip3 install qmk
        # for ps2_mouse
        sudo apt install avr-libc
        ;;
    pacman)
        sudo pip install qmk
        ;;
esac

# setup udev rule for flashing
sudo cp "$QMK_HOME/util/udev/50-qmk.rules" /etc/udev/rules.d/

# check if qmk setup is needed, not very elegant though.
if [ ! -d "$QMK_HOME/lib/chibios/.git" ]; then
    qmk setup
fi
