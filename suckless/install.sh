#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

"$PDIR/fish/install.sh"
"$PDIR/gui/install.sh"
"$PDIR/picom/install.sh"
"$PDIR/dunst/install.sh"

# install dependencies
case "$PM" in
    apt)
        sudo apt install \
            xorg libx11-dev libxft-dev libxinerama-dev \
            libxrandr-dev arandr autorandr \
            ibus ibus-table ibus-table-wubi \
            pavucontrol \
            gnome-keyring \
            xss-lock \
            nitrogen \
            trayer
        sudo apt remove gdm3
        ;;
    pacman)
        sudo pacman -S --needed \
            xorg-server xorg-xinit xorg-xrandr xorg-xev xorg-xprop \
            alsa-firmware alsa-utils alsa-plugins pulseaudio-alsa pulseaudio pavucontrol  \
            arandr autorandr \
            ibus ibus-table ibus-table-chinese \
            gnome-keyring \
            xss-lock \
            nitrogen \
            trayer
        ;;
esac

# clone / compile utilities and dwm itself
REPOS="$DIR/suckless/repos"
mkdir -p "$REPOS"

installrepo () {
    ODIR=$(pwd)
    REPO="$DIR/suckless/repos/$2"
    [ ! -d "$REPO" ] && git clone --depth "$1" "$REPO"
    cd "$REPO"
    make && sudo make install
    cd "$ODIR"
}

installrepo https://gitee.com/klesh/st.git st
installrepo https://gitee.com/klesh/dmenu.git dmenu
installrepo https://gitee.com/klesh/slock.git slock
installrepo https://github.com/klesh/dict.sh.git dict.sh
installrepo https://gitee.com/klesh/dwm.git dwm

# config xinit to start for dwm
rm ~/.xinitrc
cat <<EOT > ~/.xinitrc
#!/bin/sh

export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

export XMODIFIERS="@im=ibus"
export QT_IM_MODULE=ibus
export GTK_IM_MODULE=xim

# setup gnome keyring
dbus-update-activation-environment --systemd DISPLAY
export SSH_AUTH_SOCK=$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)

# load monitors profile
autorandr --change --force

# restart dwm if it existed without error
xrdb -query > /tmp/dwm.log
while :; do
    ssh-agent dwm 2>>/tmp/dwm.log || break
done
EOT

cat <<'EOT' > ~/.profile
#!/bin/sh

export PATH=$HOME/dotfiles/bin:$HOME/.local/bin:$PATH
export VIM_MODE=enhanced
export DMENU_DEFAULT_OPTS='-i -c -fn monospace:13 -nb #222222 -nf #bbbbbb -sb #5b97f7 -sf #eeeeee -l 20'

# auto startx
[ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq "1" ] \
    && echo $(date "+%Y%m%d-%H%M%S") '=============== auto start xinit' >> /tmp/xinit.log \
    && startx
EOT


# config dwm
[ -L "$XDG_CONFIG_HOME/dwm/autostart" ] && rm "$XDG_CONFIG_HOME/dwm/autostart"
mkdir -p "$XDG_CONFIG_HOME/dwm"
cp "$DIR/config/dwm/autostart" "$XDG_CONFIG_HOME/dwm/autostart"
lnsf "$DIR/config/autorandr/postswitch" "$XDG_CONFIG_HOME/autorandr/postswitch"
