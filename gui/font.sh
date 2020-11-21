#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up fonts'

case "$PM" in
    apt)
        # fonts
        sudo apt install -y \
            fonts-urw-base35 \
            fonts-cascadia-code \
            fonts-wqy-microhei \
            fonts-symbola \
            fonts-dejavu-core \
            gucharmap
        ;;
    pacman)
        # fonts
        sudo pacman -S --noconfirm --needed \
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
        ! fc-list | grep -qi symbola && yay -S --noconfirm --needed ttf-symbola-free
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

log 'Setting up font rendering'
sudo ln -sf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
sudo cp "$DIR/font/freetype2.sh" "/etc/profile.d/freetype2.sh"
sudo cp "$DIR/font/local.conf" "/etc/fonts/local.conf"
