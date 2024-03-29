#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

if ! has_cmd python; then
    "$PDIR/devel/python.sh"
fi

log 'Setting up picom'

# install dpes
case "$PM" in
    apt)
        # install build tools
        sudo pip3 install meson
        # install dependencies
        sudo apt install -y ninja-build libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre3-dev  libevdev-dev uthash-dev libev-dev libx11-xcb-dev
        ;;
    pacman)
        #sudo pacman -S --noconfirm --needed uthash ninja meson libev libconfig picom
        sudo pacman -S --noconfirm --needed picom
        ;;
    xbps)
        sudo xbps-install -y uthash ninja meson libev libev-devel libconfig \
            libX11-devel xcb-util-renderutil-devel xcb-util-image-devel \
            libXext-devel pixman-devel libconfig-devel pcre-devel libglvnd-devel dbus-devel
        ;;
esac

sudo cp -f "$DIR/picom/picomdaemon" "$PREFIX/bin"

# build and install picom
picom_from_src() {
    #intorepo https://github.com/klesh/picom.git "$DIR/repos/picom"
    intorepo https://github.com/yshui/picom.git "$DIR/repos/picom"
    #intorepo https://github.com/ibhagwan/picom.git "$DIR/repos/picom"
    meson --buildtype=release . build
    sudo ninja -C build install
    exitrepo
    sudo cp -f "$DIR/picom/picomdaemon" "$PREFIX/bin"
    sudo chmod +x "$PREFIX/bin/picomdaemon"
    echo 'picom installed'
}

# configuration
lnsf "$DIR/picom/picom.conf" "$XDG_CONFIG_HOME/picom/picom.conf"
