#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up fonts'

install_wqy_microhei() {
    # official wqy-microhei package doesn't fix the Korean Glyphs stacking bug
    # https://code.google.com/p/chromium/issues/detail?id=233851
    # use debian package instead
    DEB_PKG_NAME=fonts-wqy-microhei_0.2.0-beta-3_all.deb
    if [ ! -f "/tmp/$DEB_PKG_NAME" ]; then
        wget http://mirrors.163.com/debian/pool/main/f/fonts-wqy-microhei/$DEB_PKG_NAME -O /tmp/$DEB_PKG_NAME
    fi
    ar p "/tmp/$DEB_PKG_NAME" data.tar.xz | sudo tar Jxv -C /
}

case "$UNAMEA" in
    *Ubuntu*)
        # fonts
        sudo apt install -y \
            fonts-urw-base35 \
            fonts-cascadia-code \
            fonts-wqy-microhei \
            fonts-symbola \
            fonts-dejavu-core \
            gucharmap
        ;;
    *artix*)
        sudo pacman -S --noconfirm --needed \
            noto-fonts noto-fonts-cjk noto-fonts-emoji
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
    rm -rf "$LOCAL_REPO_PATH"
    git clone --single-branch --branch "$ORIGIN_NAME" --depth 1 \
        https://gitee.com/klesh/nerd-fonts.git \
        "$LOCAL_REPO_PATH"
    sudo 7z x -x!'*Windows*' -aoa "$LOCAL_REPO_PATH/$NAME" -o/usr/local/share/fonts
    sudo chmod +rx /usr/local/share/fonts
    echo "$*" | sudo tee -a /usr/local/share/fonts/nerdfont
    rm -rf "$LOCAL_REPO_PATH"
}

install_nerdfont Agave agave v2.1.0
#install_nerdfont Hermit Hurmit v2.1.0
#install_nerdfont CascadiaCode Caskaydia v2.1.0
#install_nerdfont DaddyTimeMono DaddyTimeMono v2.1.0

#log 'Setting up font rendering'
#sudo ln -sf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
#sudo ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
#sudo ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
#sudo cp "$DIR/font/freetype2.sh" "/etc/profile.d/freetype2.sh"


install_googlefont() {
    NAME=$1
    PATT=$2
    FONTS=~/.local/share/fonts
    mkdir "$FONTS"
    wget -O "/tmp/$NAME.zip" "$URL"
    unzip -d "$FONTS" "/tmp/$NAME.zip" "$PATT"
    rm "/tmp/$NAME.zip"
}

install_googlefont lato "https://fonts.google.com/download?family=Lato"
install_googlefont besley "https://fonts.google.com/download?family=Besley" "static/*"

# configuration
lnsf "$DIR/font/fonts.conf" "$XDG_CONFIG_HOME/fontconfig/fonts.conf"
