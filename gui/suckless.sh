#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up suckless'
# install dependencies
case "$PM" in
    apt)
        sudo apt install \
            dunst \
            trayer
        sudo apt remove gdm3
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed \
            trayer \
            dunst \
            xorg-xsetroot
        ;;
esac

# clone / compile utilities and dwm itself


$DIR/dmenu.sh
$DIR/slock.sh
$DRI/dict.sh
makeinstallrepo https://gitee.com/klesh/dwm.git dwm

# config xinit to start for dwm
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

cat <<'EOT' | sed "s|__PDIR__|$PDIR|g" > ~/.profile
#!/bin/sh

export PATH=__PDIR__/bin:$HOME/.local/bin:$PATH
export VIM_MODE=enhanced
export DMENU_DEFAULT_OPTS='-i -c -fn monospace:13 -nb #222222 -nf #bbbbbb -sb #5b97f7 -sf #eeeeee -l 20'
export TMUX_SHELL=$(command -v fish)

# auto startx
[ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq "1" ] \
    && startx -- -keeptty >~/.xorg.log 2>&1
EOT


# config dwm
mkdir -p "$XDG_CONFIG_HOME/dwm"
lnsf "$DIR/dwm/autostart" "$XDG_CONFIG_HOME/dwm/autostart"
