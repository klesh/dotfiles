#!/bin/bash

sudo apt install libevent-dev libncurses5-dev -y

TMUX_VER=3.1b
curl -L https://github.com/tmux/tmux/releases/download/$TMUX_VER/tmux-$TMUX_VER.tar.gz -o /tmp/tmux.tar.gz
cd /tmp/
tar zxvf tmux.tar.gz
cd tmux-$TMUX_VER
./configure && make
sudo make install
cd
rm -rf /tmp/tmux-$TMUX_VER
rm -rf /tmp/tmux.tar.gz
