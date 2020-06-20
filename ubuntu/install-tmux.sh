#!/bin/bash

set -e

sudo apt install libevent-dev libncurses5-dev -y

TMUX_VER=3.1b
#curl -L https://github.com/tmux/tmux/releases/download/$TMUX_VER/tmux-$TMUX_VER.tar.gz -o /tmp/tmux.tar.gz
[ ! -f /tmp/tmux.tar.gz ] && curl -L https://gitee.com/klesh/tmux/repository/archive/$TMUX_VER?format=tar.gz -o /tmp/tmux.tar.gz
rm -rf /tmp/tmux
mkdir -p /tmp/tmux
tar zxvf /tmp/tmux.tar.gz -C /tmp/tmux --strip 1
pushd /tmp/tmux
[ -f autogen.sh ] && sh autogen.sh
./configure && make
sudo make install
popd
rm -rf /tmp/tmux*
