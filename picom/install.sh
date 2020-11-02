#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

PICOM_VER=v8.1


# install ranger
case "$PM" in
    apt)
        # install build tools
        ! which pip3 && $ROOT/python/install.sh
        sudo pip3 install meson
        # install dependencies
        sudo apt install -y ninja-build libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre3-dev  libevdev-dev uthash-dev libev-dev libx11-xcb-dev
        ;;
    pacman)
        sudo pacman -S --needed uthash ninja meson
        ;;
esac

# build and install picom
VERSION=next
VERSION_PATH=$XDG_CONFIG_HOME/picom/version
if [ "$VERSION" = "next" ] || ! eqv "$VERSION_PATH" "$VERSION"; then
    echo Downloading picom $VERSION
    [ ! -f /tmp/picom-$VERSION.zip ] && \
        curl "https://github.com/yshui/picom/archive/$VERSION.zip" -Lo /tmp/picom-$VERSION.zip
    unzip /tmp/picom-$VERSION.zip -d /tmp
    FD=$(unzip -l /tmp/picom-$VERSION.zip | awk 'NR==5{print $4}')
    pushd /tmp/$FD
    meson --buildtype=release . build
    sudo ninja -C build install
    popd
    mkdir -p $(dirname $VERSION_PATH)
    echo "$VERSION" > "$VERSION_PATH"
    sudo rm -rf /tmp/picom-$VERSION*
fi

# configuration
lnsf $DIR/config/launch.sh $XDG_CONFIG_HOME/picom/launch.sh
lnsf $DIR/config/toggle.sh $XDG_CONFIG_HOME/picom/toggle.sh
lnsf $DIR/config/picom.conf $XDG_CONFIG_HOME/picom/picom.conf
