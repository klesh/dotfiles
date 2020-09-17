#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

echo Installing fonts
# install fonts
case "$PM" in
    apt)
        sudo apt install \
            fonts-wqy-microhei \
            fonts-droid-fallback \
            fonts-cascadia-code \
            ttf-dejavu \
            gucharmap
        ;;
    pacman)
        sudo pacman -S \
            terminus-font \
            ttf-droid \
            freetype2 \
            ttf-cascadia-code \
            ttf-dejavu \
            wqy-microhei-lite \
            gucharmap
        echo TO DO
        exit -1
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

# configuration
sudo ln -sf /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -sf /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
sudo cp $DIR/freetype2.sh /etc/profile.d/freetype2.sh
sudo cp $DIR/local.conf /etc/fonts/local.conf
