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
            xclip xsel \
            xdotool \
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
        # laptop utitlies
        if is_laptop; then
            sudo apt install \
                acpilght tlp
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
            thunar gvfs-smb gvfs-mtp thunar-archive-plugin file-roller tumbler \
            clang
        # bluetooth
        if has_bluetooth; then
            sudo pacman -S --noconfirm --needed \
                bluez bluez-utils blueman
            sudo systemctl enable bluetooth
            sudo systemctl start bluetooth
            # bluetoothctl devices
            # bluetoothctl pair <ADDR>
            # bluetoothctl trust <ADDR>
            # bluetoothctl connect <ADDR>
        fi
        if is_laptop; then
            sudo pacman -S --noconfirm --needed \
                acpilght tlp
        fi
        ;;
    xbps)
        sudo xbps-install -y xorg dbus gnome-keyring libgnome-keyring \
            nitrogen xsel xdotool xclip flameshot clang pkg-config chrony \
            Thunar gvfs-smb gvfs-mtp thunar-archive-plugin file-roller tumbler \
            pipewire pipewire-pulse alsa-pipewire alsa-utils pulseaudio-utils pavucontrol libpulseaudio \
            ibus ibus-rime \
            base-devel libX11-devel libXft-devel libXinerama-devel \
            socklog-void
        # config alsa
        sudo mkdir -p /etc/alsa/conf.d
        sudo ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
        sudo ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
        # enable ntp
        sudo ln -sf /etc/sv/chronyd /var/service/
        # enable logging
        sudo ln -sf /etc/sv/socklog-unix /var/service/
        sudo ln -sf /etc/sv/nanoklogd /var/service/
        echo "Wubi"
        echo "download rime-data-wubi from http://mirrors.163.com/ubuntu/pool/universe/r/rime-wubi/rime-data-wubi_0.0~git20200908.f1876f0-3_amd64.deb"
        echo "  ar x rime-data-wubi_0.0~git20200908.f1876f0-3_amd64.deb"
        echo "  unzstd data.zst"
        echo "  cd /"
        echo "  sudo tar xvf /home/klesh/Downloads/rime-data-wubi/data.tar"
        echo "  sudo vim /usr/share/rime-data/default.yaml"
        echo "add wub86 to schema"
        echo "restart ibus"
        echo "add rime , done"
        ;;
esac

lnsf "$DIR/thunar/uca.xml" "$XDG_CONFIG_HOME/Thunar/uca.xml"

# start network
if has_cmd systemctl; then
    sudo systemctl enable NetworkManagerXF86AudioRaiseVolume
    sudo systemctl start NetworkManager
    sudo systemctl enable autorandr
    sudo systemctl start autorandr

    lnsf "$DIR/dunst/dunstrc" "$XDG_CONFIG_HOME/dunst/dunstrc"

    echo for non-root user to change backlight, add following rule to /etc/udev/rules.d/backlight.rules
    echo ```
    echo ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", GROUP="video", MODE="0664"
    echo ```
    echo for intel_backlight:
    echo ```
    echo RUN+="/bin/chgrp video /sys/class/backlight/intel_backlight/brightness"
    echo RUN+="/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness"
    echo ```

    echo for amd ryzen laptop add "acpi_backlight=vendor" to /etc/default/grub and then run
    echo sudo grub-mkconfig -o /boot/grub/grub.cfg
fi
