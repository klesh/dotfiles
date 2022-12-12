#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up neomutt'

case "$PM" in
    pacman)
        sudo pacman -S --noconfirm --needed neomutt isync lynx notmuch cronie urlscan
        yay -S --noconfirm --needed abook cyrus-sasl-xoauth2-git
        ;;
    apt)
        sudo apt install -y  gettext libgettextpo-dev libxml2-utils xsltproc libidn11-dev libsasl2-dev liblmdb-dev \
            perl libssl-dev libnotmuch-dev msmtp lynx urlscan

        # neomutt
        git clone git@github.com:neomutt/neomutt.git ~/Projects/klesh/neomutt
        cd ~/Projects/klesh/neomutt
        ./configure --disable-doc --sasl --with-lmdb=/usr/lib
        make
        sudo make install

        # mutt-wizard
        git clone git@github.com:LukeSmithxyz/mutt-wizard.git ~/Projects/klesh/mutt-wizard
        cd ~/Projects/klesh/mutt-wizard
        sudo make install
        git clone git clone https://git.code.sf.net/p/isync/isync isync-isync ~/Project/klesh/isync-isync

        # isync
        sudo cpan install Date::Parse
        cd ~/Projects/klesh/isync-isync
        ./autogen.sh
        ./configure
        make
        sudo make install
esac


case "$UNAMEA" in
    *artix*)
        sudo pacman -S --noconfirm --needed cronie-runit
        sudo ln -sf /etc/runit/sv/cronie/ /run/runit/service/
        ;;
esac


makeinstallrepo https://github.com/klesh/mutt-wizard.git mutt-wizard
