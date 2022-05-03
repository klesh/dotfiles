#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up awesome'

case "$PM" in
    apt)
        ;;
    pacman)
        ;;
    xbps)
        sudo xbps-install -y awesome
        ;;
esac


# necessary tools
$DIR/dmenu.sh
$DIR/slock.sh
$DRI/dict.sh

# install widgets
HTTPS_PROXY=$GITHUB_PROXY git clone https://github.com/klesh/awesome-wm-widgets.git "$XDG_CONFIG_HOME/awesome/awesome-wm-widgets"

# ~/.xinitrc
cat <<EOT > ~/.xinitrc
export XMODIFIERS="@im=ibus"
export QT_IM_MODULE=ibus
export GTK_IM_MODULE=xim
export VIM_MODE=enhanced
export DMENU_DEFAULT_OPTS='-i -c -fn monospace:13 -nb #222222 -nf #bbbbbb -sb #5b97f7 -sf #eeeeee -l 20'
export TMUX_SHELL=/usr/bin/fish
export XDG_RUNTIME_DIR=/tmp/runtime-klesh

exec dbus-run-session -- awesome 2> /tmp/awesome.log
EOT


# ~/.profile
cat <<'EOT' | sed "s|__PDIR__|$PDIR|g" > ~/.profile
export WINIP=localhost
export PATH=~/dotfiles/bin:~/.local/bin:$PATH

#Startx Automatically
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]; then
    startx
fi
EOT


# configuration
lnsf "$DIR/awesome/rc.lua" "$XDG_CONFIG_HOME/awesome/rc.lua"
