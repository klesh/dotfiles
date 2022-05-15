#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up awesome'

case "$UNAMER" in
    *artix*)
        sudo pacman -S --noconfirm --needed awesome rofi
        ;;
esac


# necessary tools
#$DIR/dmenu.sh
#$DIR/slock.sh
$DIR/dict.sh

# install widgets
if [ ! -d "$XDG_CONFIG_HOME/awesome/awesome-wm-widgets" ]; then
    echo cloning awesome widget
    git clone https://gitee.com/klesh/awesome-wm-widgets.git "$XDG_CONFIG_HOME/awesome/awesome-wm-widgets"
fi

# ~/.xinitrc
cat <<'EOT' > ~/.xinitrc
export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

export XMODIFIERS="@im=ibus"
export QT_IM_MODULE=ibus
export GTK_IM_MODULE=xim
export VIM_MODE=enhanced
export XDG_RUNTIME_DIR=/tmp/runtime-klesh
mkdir -p $XDG_RUNTIME_DIR

exec dbus-run-session -- awesome 2> /tmp/awesome.log
EOT


# ~/.profile
cat <<'EOT' | sed "s|__PDIR__|$PDIR|g" > ~/.profile
export PROXY_HOST=localhost
export PROXY_PORT=4780
export PROXY_PROTO=http
export TMUX_SHELL=/usr/bin/fish
export PATH=~/dotfiles/bin:~/.local/bin:$PATH

# startx Automatically
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]; then
    startx
fi
EOT


# configuration
lnsf "$DIR/awesome/rc.lua" "$XDG_CONFIG_HOME/awesome/rc.lua"
lnsf "$DIR/rofi/config.rasi" "$XDG_CONFIG_HOME/rofi/config.rasi"
lnsf "$DIR/rofi/catppuccin.rasi" "$XDG_CONFIG_HOME/rofi/catppuccin.rasi"
