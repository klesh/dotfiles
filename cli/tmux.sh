#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up tmux'

case "$PM" in
    apt)
        TMUX_VER=3.2a
        if ! has_cmd tmux || [ "$(tmux -V)" != "tmux $TMUX_VER" ]; then
            sudo apt install libevent-dev libncurses5-dev bison autoconf bc -y
            TMUX_SRC_URL=https://github.com/tmux/tmux/releases/download/$TMUX_VER/tmux-$TMUX_VER.tar.gz
            #if in_china; then
                #TMUX_SRC_URL="https://gitee.com/klesh/tmux/repository/archive/$TMUX_VER?format=tar.gz"
            #fi
            if [ ! -f /tmp/tmux.tar.gz ]; then
                curl -L "$TMUX_SRC_URL" -o /tmp/tmux.tar.gz
            fi
            rm -rf /tmp/tmux
            mkdir -p /tmp/tmux
            tar zxvf /tmp/tmux.tar.gz -C /tmp/tmux --strip 1
            cd /tmp/tmux
            if [ -f autogen.sh ]; then
                sh autogen.sh
            fi
            ./configure && make
            sudo make install
            cd -
            rm -rf /tmp/tmux
        fi
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed tmux bc
        ;;
esac

# symlink configuration
lnsf "$DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
lnsf "$DIR/tmux/tmux2.8.conf" "$XDG_CONFIG_HOME/tmux/tmux2.8.conf"
lnsf "$DIR/tmux/tmux2.9.conf" "$XDG_CONFIG_HOME/tmux/tmux2.9.conf"
