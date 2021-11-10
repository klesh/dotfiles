#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

if ! has_cmd go; then
    "$PDIR/devel/go.sh"
fi
GNUPG=$HOME/.gnupg
GPG_AGENT_CONF=$GNUPG/gpg-agent.conf
mkdir -p "$GNUPG"

# install pass
case "$PM" in
    apt)
        sudo apt install -y pass
        if [ -n "$WSL" ]; then
            PINENTRY=$PDIR/bin/pinentry-wsl-ps1.sh
            BROWSERPASS_NATIVE="$(wsl-win-path.sh %USERPROFILE%)/browser-wsl.bat"
            echo "@echo off\r\nbash -c 'browserpass'" \
                > "$BROWSERPASS_NATIVE"
        else
            sudo apt install -y pinentry-gtk2
            PINENTRY=$(command -v pinentry-gtk-2)
        fi
        SETTING="pinentry-program $PINENTRY"
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed \
            go \
            browserpass
        ;;
esac

# longer password caching time
cat <<EOF >  ~/.gnupg/gpg-agent.conf
$SETTING
default-cache-ttl 28800
max-cache-ttl 28800
EOF


# install browserpass-native
intorepo https://github.com/browserpass/browserpass-native.git "$DIR/repos/browserpass-native"
make configure
make
sudo make install
exitrepo
if [ -n "$WSL" ]; then
    echo "Please download browserpass-native for windows 64 and extract it to /usr/local/bin"
    x-open https://github.com/browserpass/browserpass-native/releases/latest
fi

# enable browser-native for google-chrome
#make -C /usr/lib/browserpass hosts-chrome-user


# chrome extension: https://chrome.google.com/webstore/detail/browserpass/naepdomgkenhinolocfifgehidddafch

# enable browserpass for browsers
if [ -f /usr/lib/browserpass ]; then
    cd /usr/lib/browserpass
    has_cmd chromium && make hosts-chromium-user
    has_cmd firefox && make hosts-firefox-user
    has_cmd google-chrome && make hosts-chrome-user
    cd -
fi

# android
# [OpenKeyChain - encryption/decryption](https://f-droid.org/packages/org.sufficientlysecure.keychain/)
# [PasswordStore - sync / ui](https://f-droid.org/packages/dev.msfjarvis.aps/)

# configuration

if [ -n "$WSL" ]; then
    echo "Please update path in *-host.json file located at C:\Program Files\Browserpass to"
    echo $BROWSERPASS_NATIVE
fi
