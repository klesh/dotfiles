#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up system utilities X11 ime keyring clipboard screenshot filemanager network bluetooth'

case "$UNAMEA" in
    *Ubuntu*)
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
            copyq \
            thunar gvfs-bin gvfs-backends thunar-archive-plugin file-roller tumbler
        # desktop notification
        lnsf "$DIR/dunst/dunstrc" "$XDG_CONFIG_HOME/dunst/dunstrc"
        # network
        sudo systemctl start NetworkManager
        # bluetooth
        if has_bluetooth; then
            sudo apt install \
                bluez bluez-tools blueman pulseaudio-module-bluetooth
            sudo systemctl enable bluetooth
            sudo systemctl start bluetooth
        fi
        # laptop
        if is_laptop; then
            sudo apt install \
                acpilght tlp
            sudo systemctl enable autorandr
            sudo systemctl start autorandr
        fi
        ;;
    *artix*)
        sudo pacman -S --noconfirm --needed \
            xorg-server xorg-xinit xorg-xrandr xorg-xprop xorg-xev xdotool \
            pulseaudio pulseaudio-alsa pulseaudio-bluetooth alsa-utils pavucontrol \
            xclip xsel \
            clang \
            ibus ibus-rime rime-wubi \
            networkmanager network-manager-applet \
            exfat-utils \
            gnome-keyring libsecret \
            thunar gvfs-smb gvfs-mtp thunar-archive-plugin file-roller tumbler \
            flameshot \
            copyq \
            alacritty
        # ntp
        sudo pacman -S --noconfirm --needed \
            chrony chrony-runit
        sudo ln -sf /etc/runit/sv/chrony/ /run/runit/service/
        # ime
        RIME_CFG="$XDG_CONFIG_HOME/ibus/rime/build/default.yaml"
        if ! grep -F "wubi86" "$RIME_CFG"; then
            sed -i 's/schema_list:/schema_list:\n  - schema: wubi86/' "$RIME_CFG"
        fi
        # bluetooth
        if has_bluetooth; then
            sudo pacman -S --noconfirm --needed \
                bluez bluez-utils blueman
            # bluetoothctl devices
            # bluetoothctl pair <ADDR>
            # bluetoothctl trust <ADDR>
            # bluetoothctl connect <ADDR>
            sudo ln -sf /etc/runit/sv/bluetoothd /run/runit/service/
        fi
        # laptop
        if is_laptop; then
            sudo pacman -S --noconfirm --needed \
                arandr autorandr \
                acpi light python-pip
            yay -S --needed --noconfirm auto-cpufreq-git
            sudo mkdir -p /etc/runit/sv/auto-cpufreq
            sudo cp $DIR/auto-cpufreq/auto-cpufreq-runit /etc/runit/sv/auto-cpufreq/run
            sudo chmod +x /etc/runit/sv/auto-cpufreq/run
            sudo ln -sf /etc/runit/sv/auto-cpufreq/ /run/runit/service/
        fi
        ;;
esac


# configuration
lnsf "$DIR/autorandr/postswitch" "$XDG_CONFIG_HOME/autorandr/postswitch"
lnsf "$DIR/thunar/uca.xml" "$XDG_CONFIG_HOME/Thunar/uca.xml"
lnsf "$DIR/alacritty/alacritty.yml" "$XDG_CONFIG_HOME/alacritty/alacritty.yml"

if is_laptop; then
    echo for non-root user to change backlight, add following rule to /etc/udev/rules.d/backlight.rules
    echo ```
    echo ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", GROUP="video", MODE="0664"
    echo ```
    echo for intel_backlight:
    echo ```
    echo RUN+="/bin/chgrp video /sys/class/backlight/intel_backlight/brightness"
    echo RUN+="/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness"
    echo ```

fi

# auto execute autorandr for monitor hotplug
echo 'ACTION=="change", SUBSYSTEM=="drm", RUN+="/usr/bin/autorandr --batch --change --force"' \
    > sudo tee /etc/udev/rules.d/40-monitor-hotplug.rules

