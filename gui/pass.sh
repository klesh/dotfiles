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
chmod 700 "$GNUPG"

# install pass
case "$PM" in
    apt)
        sudo apt install -y pass
        if [ -n "$WSL" ]; then
            PINENTRY=$PDIR/bin/pinentry-wsl-ps1.sh
            BROWSERPASS_NATIVE="$(wsl-win-path.sh %USERPROFILE%)/browserpass-wsl.bat"
            echo "@echo off\r\nbash -c 'browserpass'" \
                > "$BROWSERPASS_NATIVE"
        else
            sudo apt install -y pinentry-gtk2
            PINENTRY=$(command -v pinentry-gtk-2)
        fi
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed \
            go \
            browserpass pass pinentry
        PINENTRY=$(command -v pinentry-qt)
        ;;
    xbps)
        sudo xbps-install -y go browserpass pass pinentry
        PINENTRY=$(command -v pinentry-qt)
        ;;
esac

# longer password caching time
cat <<EOF >  ~/.gnupg/gpg-agent.conf
pinentry-program $PINENTRY
default-cache-ttl 43200
max-cache-ttl 43200
EOF


# install browserpass-native
intorepo https://github.com/browserpass/browserpass-native.git "$DIR/repos/browserpass-native"
make configure
make
sudo make install
exitrepo

# enable browser-native for google-chrome
#make -C /usr/lib/browserpass hosts-chrome-user


# chrome extension: https://chrome.google.com/webstore/detail/browserpass/naepdomgkenhinolocfifgehidddafch

# enable browserpass for browsers
if [ -d /usr/lib/browserpass ]; then
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
    echo 'Please update path in files "C:\Program Files\Browserpass\*-host.json" to'
    cmd.exe /c 'echo %USERPROFILE%\browserpass-wsl.bat' 2>/dev/null | sed 's/\\/\\\\/g'
fi
