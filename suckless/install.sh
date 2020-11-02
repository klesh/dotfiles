#!/bin/sh

DIR=$(readlink -f "$(dirname "$0")")
. "$DIR/../env.sh"

"$ROOT/fish/install.sh"
"$ROOT/gui/install.sh"
"$ROOT/picom/install.sh"
"$ROOT/dunst/install.sh"

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
mkdir -p ~/Projects/suckless

[ ! -d ~/Projects/suckless/st ] && git clone https://gitee.com/klesh/st.git ~/Projects/suckless/st
cd ~/Projects/suckless/st && sudo rm -f config.h && sudo make clean install

[ ! -d ~/Projects/suckless/dmenu ] &&git clone https://gitee.com/klesh/dmenu.git ~/Projects/suckless/dmenu
cd ~/Projects/suckless/dmenu && sudo rm -f config.h && sudo make clean install

[ ! -d ~/Projects/suckless/slock ] &&git clone https://gitee.com/klesh/slock.git ~/Projects/suckless/slock
cd ~/Projects/suckless/slock && sudo rm -f config.h && sudo make clean install

[ ! -d ~/Projects/suckless/dwm ] &&git clone https://gitee.com/klesh/dwm.git ~/Projects/suckless/dwm
cd ~/Projects/suckless/dwm && sudo rm -f config.h && sudo make clean install

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
while :; do
    ssh-agent dwm 2>/tmp/dwm.log || break
done
EOT

cat <<'EOT' > ~/.profile
#!/bin/sh

export PATH=$HOME/.local/bin

# auto startx
[ -z "$DISPLAY" -a -n "$XDG_VTNR" -a "$XDG_VTNR" -eq "1" ] && exec startx
EOT


# config dwm
[ -L "$XDG_CONFIG_HOME/dwm/autostart" ] && rm "$XDG_CONFIG_HOME/dwm/autostart"
mkdir -p "$XDG_CONFIG_HOME/dwm"
cp "$DIR/config/dwm/autostart" "$XDG_CONFIG_HOME/dwm/autostart"
lnsf "$DIR/config/dwm/statusbar" "$XDG_CONFIG_HOME/dwm/statusbar"
lnsf "$DIR/config/autorandr/postswitch" "$XDG_CONFIG_HOME/autorandr/postswitch"
