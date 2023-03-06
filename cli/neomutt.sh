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
            perl libssl-dev libnotmuch-dev msmtp lynx urlscan libtool notmuch

        # neomutt
        if ! command -v neomutt; then
            git clone https://github.com/neomutt/neomutt ~/Projects/klesh/neomutt
            cd ~/Projects/klesh/neomutt
            ./configure --disable-doc --sasl --with-lmdb=/usr/lib
            make
            sudo make install
        fi

        # mutt-wizard
        if ! command -v mailsync; then
            git clone https://github.com/LukeSmithxyz/mutt-wizard ~/Projects/klesh/mutt-wizard
            cd ~/Projects/klesh/mutt-wizard
            sudo make install
        fi

        # isync
        if ! command -v mbsync; then
            sudo cpan install Date::Parse
            git clone https://git.code.sf.net/p/isync/isync ~/Projects/klesh/isync
            cd ~/Projects/klesh/isync
            ./autogen.sh
            ./configure
            make
            sudo make install
        fi

        # isync xoauth2
        git clone https://github.com/moriyoshi/cyrus-sasl-xoauth2.git ~/Projects/klesh/cyrus-sasl-xoauth2
        cd ~/Projects/klesh/cyrus-sasl-xoauth2
        ./autogen.sh
        ./configure
        sed -i 's%pkglibdir = ${CYRUS_SASL_PREFIX}/lib/sasl2%pkglibdir = ${CYRUS_SASL_PREFIX}/lib/x86_64-linux-gnu/sasl2%' Makefile
        make
        sudo make install

        # lynx with gbk support
        if ! grep "ASSUME_UNREC_CHARSET:euc-cn" /etc/lynx/lynx.cfg; then
            echo "ASSUME_UNREC_CHARSET:euc-cn" | sudo tee -a /etc/lynx/lynx.cfg 
        fi
esac


case "$UNAMEA" in
    *artix*)
        sudo pacman -S --noconfirm --needed cronie-runit
        sudo ln -sf /etc/runit/sv/cronie/ /run/runit/service/
        ;;
esac


makeinstallrepo https://github.com/klesh/mutt-wizard.git mutt-wizard
