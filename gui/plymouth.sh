#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up plymouth'

# install dpes
case "$PM" in
    apt)
        # install build tools
        echo "to do"
        exit -1
        ;;
    pacman)
        ! has_cmd plymouth && yay -S --noconfirm --needed plymouth
        ;;
esac

# configuration
awk -F= '$1 == "HOOKS" && $2 !~ / udev plymouth / { sub(" udev ", " udev plymouth ") }; {print}' \
    /etc/mkinitcpio.conf \
    | sudo tee /etc/mkinitcpio.conf
#sudo mkinitcpio -p linux

awk '$0 ~ "^GRUB_CMDLINE_LINUX_DEFAULT=" && $0 !~ / splash / { sub("quiet", "quiet splash vt.global_cursor_default=0") }; {print}' \
    /etc/default/grub \
    | sudo tee /etc/default/grub \
    && sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo plymouth-set-default-theme -R spinfinity
