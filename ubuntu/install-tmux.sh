#!/bin/bash

set -e

sudo apt install libevent-dev libncurses5-dev -y

TMUX_VER=3.1b
#curl -L https://github.com/tmux/tmux/releases/download/$TMUX_VER/tmux-$TMUX_VER.tar.gz -o /tmp/tmux.tar.gz
curl -L https://gitee.com/klesh/tmux/repository/archive/$TMUX_VER?format=tar.gz -o /tmp/tmux.tar.gz
mkdir -p /tmp/tmux
tar zxvf /tmp/tmux.tar.gz -C /tmp/tmux
pushd /tmp/tmux
[ -f autogen.sh ] && sh autogen.sh
./configure && make
sudo make install
rm -rf /tmp/tmux
rm -rf /tmp/tmux.tar.gz
popd
