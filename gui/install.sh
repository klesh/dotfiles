#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install basic gui stuff, including fonts/system utilties/keyring etc
case "$PM" in
    apt)
        # fonts
        sudo apt install \
            fonts-cascadia-code \
            fonts-droid-fallback \
            fonts-urw-base35 \
            fonts-symbola \
            gucharmap
        # network manager
        sudo apt install \
            network-manager network-manager-gnome
        # bluetooth
        if has-bluetooth; then
            sudo apt install \
                bluez bluez-tools blueman pulseaudio-module-bluetooth
            sudo systemctl enable bluetooth
            sudo systemctl start bluetooth
        fi
        ;;
    pacman)
        # fonts
        sudo pacman -S --needed \
            freetype2 \
            ttf-cascadia-code \
            gsfonts \
            ttf-droid \
            wqy-microhei \
            gucharmap
        # install symbola for plain emojis(no-color) for st
        yay -S ttf-symbola-free
        # clipboard
        sudo pacman -S --needed \
            xclip xsel
        # keyring
        sudo pacman -S --needed \
            gnome-keyring libsecret
        # network manager
        sudo pacman -S --needed \
            networkmanager network-manager-applet
        # bluetooth
        if has-bluetooth; then
            sudo pacman -S --needed \
                bluez bluez-utils blueman pulseaudio-bluetooth xorg-xbacklight
            sudo systemctl enable bluetooth
            sudo systemctl start bluetooth
        fi
        # for setting up default programs: exo-preferred-applications
        sudo pacman -S --needed exo
        ;;
esac


# install hermit nerd font
if ! ls /usr/share/fonts | grep -i hurmit > /dev/null; then
    if [ ! -f /tmp/hermit.zip ]; then
        if in-china; then
            git clone https://gitee.com/klesh/nerd-fonts.git /tmp/nerd-fonts
            mv /tmp/nerd-fonts/Hermit-v2.1.0.zip /tmp/hermit.zip
            rm -rf /tmp/nerd-fonts
        else
            echo 'for rest of the world'
            HNF_PATH=$(curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest | grep -i hermit | sed -n 's/.*href="\([^"]*\).*/\1/p')
            HNF_URL="https://github.com$HNF_PATH"
            curl -L $HNF_URL --output /tmp/hermit.zip || rm -rf /tmp/hermit.zip && false
        fi
    fi
    unzip /tmp/hermit.zip -d /tmp/hermit
    rm /tmp/hermit/*Windows*
    sudo cp /tmp/hermit/* /usr/share/fonts
fi

# start network
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# configuration
sudo ln -sf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
sudo cp $DIR/freetype2.sh /etc/profile.d/freetype2.sh
sudo cp $DIR/local.conf /etc/fonts/local.conf
