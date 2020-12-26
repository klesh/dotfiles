#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

if ! has_cmd go; then
    "$PDIR/devel/go.sh"
fi

# install pass
case "$PM" in
    apt)
        sudo apt install -y pass pinentry-gtk2
        GNUPG=$HOME/.gnupg
        GPG_AGENT_CONF=$GNUPG/gpg-agent.conf
        PINENTRY=$(command -v pinentry-gtk-2)
        SETTING="pinentry-program $PINENTRY"
        mkdir -p "$GNUPG"
        if ! grep -Fq "$SETTING" "$GPG_AGENT_CONF"; then
            echo "$SETTING" > GPG_AGENT_CONF
        fi
        ;;
    pacman)
        # TODO
        sudo pacman -S --noconfirm --needed \
            go
        ;;
esac

# install browserpass-native
intorepo https://github.com/browserpass/browserpass-native.git "$DIR/repos/browserpass-native"
make configure
make
sudo make install
exitrepo

# chrome extension: https://chrome.google.com/webstore/detail/browserpass/naepdomgkenhinolocfifgehidddafch

# enable browserpass for browsers
cd /usr/lib/browserpass
has_cmd chromium && make hosts-chromium-user
has_cmd firefox && make hosts-firefox-user
has_cmd google-chrome && make hosts-chrome-user
cd -

# configuration
