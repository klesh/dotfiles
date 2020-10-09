#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install basic gui stuff, including fonts/system utilties/keyring etc
case "$PM" in
    apt)
        # fonts
        sudo apt install \
            fonts-urw-base35 \
            fonts-cascadia-code \
            fonts-wqy-microhei \
            fonts-symbola \
            fonts-dejavu-core \
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
            gsfonts \
            ttf-cascadia-code \
            wqy-microhei \
            ttf-dejavu \
            gucharmap
        # install symbola for plain emojis(no-color) for st
        yay -S --needed ttf-symbola-free
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
install-nerdfont () {
    ORIGIN_NAME=$1
    PATCHED_PAT=$2
    VERSION=$3
    NAME=$ORIGIN_NAME-$VERSION.zip
    LOCAL_REPO_PATH=/tmp/nerd-font/$ORIGIN_NAME
    # shortcircuit if font already in system
    fc-list | grep -F $0 | grep -i nerd && return
    # clone single branch from gitee
    git clone --single-branch --branch $ORIGIN_NAME --depth 1 \
        https://gitee.com/klesh/nerd-fonts.git \
        $LOCAL_REPO_PATH
    sudo 7z x -x!'*Windows*' -aoa $LOCAL_REPO_PATH/$NAME -o/usr/local/share/fonts
    sudo chmod +x /usr/local/share/fonts
    echo $LOCAL_REPO_PATH
    rm -rf $LOCAL_REPO_PATH
}

#install-nerdfont Hermit Hurmit v2.1.0
install-nerdfont Agave agave v2.1.0
#install-nerdfont CascadiaCode Caskaydia v2.1.0
#install-nerdfont DaddyTimeMono DaddyTimeMono v2.1.0

# start network
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# configuration
sudo ln -sf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
sudo cp $DIR/freetype2.sh /etc/profile.d/freetype2.sh
sudo cp $DIR/local.conf /etc/fonts/local.conf
