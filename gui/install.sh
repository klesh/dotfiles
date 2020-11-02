#!/bin/sh

DIR=$(readlink -f "$(dirname "$0")")
. "$DIR/../env.sh"

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
        if has_bluetooth; then
            sudo apt install \
                bluez bluez-tools blueman pulseaudio-module-bluetooth
            sudo systemctl enable bluetooth
            sudo systemctl start bluetooth
        # system utils
        sudo apt install \
            exfat-utils \
            axel
        fi
        ;;
    pacman)
        # fonts
        sudo pacman -S --needed \
            freetype2 \
            gsfonts \
            ttf-cascadia-code \
            ttf-dejavu \
            gucharmap
        # official wqy-microhei package doesn't fix the Korean Glyphs stacking bug
        # https://code.google.com/p/chromium/issues/detail?id=233851
        # use debian package instead
        DEB_PKG_NAME=fonts-wqy-microhei_0.2.0-beta-3_all.deb
        [ ! -f "/tmp/$DEB_PKG_NAME" ] && \
            wget http://mirrors.163.com/debian/pool/main/f/fonts-wqy-microhei/$DEB_PKG_NAME -O /tmp/$DEB_PKG_NAME
        ar p "/tmp/$DEB_PKG_NAME" data.tar.xz | sudo tar Jxv -C /
        # install symbola for plain emojis(no-color) for st
        ! fc-list | grep -qi symbola && yay -S --needed ttf-symbola-free
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
        if has_bluetooth; then
            sudo pacman -S --needed \
                bluez bluez-utils blueman pulseaudio-bluetooth xorg-xbacklight
            sudo systemctl enable bluetooth
            sudo systemctl start bluetooth
        fi
        # for setting up default programs: exo-preferred-applications
        sudo pacman -S --needed \
            exfat-utils \
            axel \
            exo
        ;;
esac


# install hermit nerd font
install_nerdfont () {
    grep -F "$*" /usr/local/share/fonts/nerdfont && return
    ORIGIN_NAME=$1
    PATCHED_PAT=$2
    VERSION=$3
    NAME=$ORIGIN_NAME-$VERSION.zip
    LOCAL_REPO_PATH=/tmp/nerd-font/$ORIGIN_NAME
    # shortcircuit if font already in system
    fc-list | grep -F "$PATCHED_PAT" | grep -i nerd && return
    # clone single branch from gitee
    git clone --single-branch --branch "$ORIGIN_NAME" --depth 1 \
        https://gitee.com/klesh/nerd-fonts.git \
        "$LOCAL_REPO_PATH"
    sudo 7z x -x!'*Windows*' -aoa "$LOCAL_REPO_PATH/$NAME" -o/usr/local/share/fonts
    sudo chmod +rx /usr/local/share/fonts
    echo "$*" | sudo tee -a /usr/local/share/fonts/nerdfont
    rm -rf "$LOCAL_REPO_PATH"
}

#install_nerdfont Hermit Hurmit v2.1.0
install_nerdfont Agave agave v2.1.0
#install_nerdfont CascadiaCode Caskaydia v2.1.0
#install_nerdfont DaddyTimeMono DaddyTimeMono v2.1.0

# start network
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# configuration
sudo ln -sf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
sudo cp "$DIR/freetype2.sh" "/etc/profile.d/freetype2.sh"
sudo cp "$DIR/local.conf" "/etc/fonts/local.conf"
