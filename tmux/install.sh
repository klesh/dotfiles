#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

TMUX_VER=3.1b

# install ranger
case "$PM" in
    apt)
        sudo apt install libevent-dev libncurses5-dev bison autoconf bc -y
        TMUX_SRC_URL=https://github.com/tmux/tmux/releases/download/$TMUX_VER/tmux-$TMUX_VER.tar.gz
        if in-china; then
            TMUX_SRC_URL=https://gitee.com/klesh/tmux/repository/archive/$TMUX_VER?format=tar.gz
        fi
        [ ! -f /tmp/tmux.tar.gz ] && curl -L $TMUX_SRC_URL -o /tmp/tmux.tar.gz
        rm -rf /tmp/tmux
        mkdir -p /tmp/tmux
        tar zxvf /tmp/tmux.tar.gz -C /tmp/tmux --strip 1
        pushd /tmp/tmux
        [ -f autogen.sh ] && sh autogen.sh
        ./configure && make
        sudo make install
        popd
        rm -rf /tmp/tmux*
        ;;
    pacman)
        sudo pacman -S --needed tmux bc
        ;;
esac

# symlink configuration
lnsf $DIR/tmux.conf ~/.tmux.conf
lnsf $DIR/config $XDG_CONFIG_HOME/tmux
