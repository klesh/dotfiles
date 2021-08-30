#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up system utilities X11 ibus keyring dunst clipboard screenshot thunar network bluetooth'

case "$PM" in
    apt)
        sudo apt install -y \
            xorg libx11-dev libxft-dev libxinerama-dev libxcursor-dev \
            libxrandr-dev arandr autorandr \
            pavucontrol \
            ibus ibus-table ibus-table-wubi \
            gnome-keyring \
            xss-lock \
            nitrogen \
            network-manager network-manager-gnome \
            exfat-utils \
            dunst \
            xclip xsel xdotool \
            libnotify-bin \
            flameshot scrot \
            thunar gvfs-bin gvfs-backends thunar-archive-plugin file-roller tumbler
        # bluetooth
        if has_bluetooth; then
            sudo apt install \
                bluez bluez-tools blueman pulseaudio-module-bluetooth
            sudo systemctl enable bluetooth
            sudo systemctl start bluetooth
        fi
        ;;
    pacman)
        # for setting up default programs: exo-preferred-applications
        sudo pacman -S --noconfirm --needed \
            xorg-server xorg-xinit xorg-xrandr xorg-xev xorg-xprop \
            arandr autorandr \
            alsa-firmware alsa-utils alsa-plugins pulseaudio-alsa pipewire-pulse pavucontrol  \
            ibus ibus-table ibus-table-chinese \
            gnome-keyring \
            xss-lock \
            nitrogen \
            networkmanager network-manager-applet \
            exfat-utils \
            exo \
            dunst \
            xclip xsel xdotool \
            gnome-keyring libsecret \
            flameshot scrot \
            thunar gvfs-smb gvfs-mtp thunar-archive-plugin file-roller tumbler
        # bluetooth
        if has_bluetooth; then
            sudo pacman -S --noconfirm --needed \
                bluez bluez-utils blueman acpilight
            sudo systemctl enable bluetooth
            sudo systemctl start bluetooth
        fi
        ;;
esac

# start network
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo systemctl enable autorandr
sudo systemctl start autorandr

lnsf "$DIR/dunst/dunstrc" "$XDG_CONFIG_HOME/dunst/dunstrc"
lnsf "$DIR/thunar/uca.xml" "$XDG_CONFIG_HOME/Thunar/uca.xml"
