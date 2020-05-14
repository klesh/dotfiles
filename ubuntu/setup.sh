#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
if [ ! -e /etc/apt/sources.bak ]; then
  sudo mv /etc/apt/sources.list /etc/apt/sources.bak

  CURRENT_CODENAME=$(lsb_release -c | cut -f2)
  SOURCE_CODENAME=$(head -n 1 $DIR/sources.list | cut -d' ' -f3)
  if [ "$CURRENT_CODENAME" != "$SOURCE_CODENAME" ]; then
    sudo bash -c "cat $DIR/sources.list | sed s/$SOURCE_CODENAME/$CURRENT_CODENAME/g > /etc/apt/sources.list"
  else
    sudo cp $DIR/sources.list /etc/apt/
  fi
fi

sudo add-apt-repository ppa:jonathonf/vim -y
sudo add-apt-repository ppa:fish-shell/release-3 -y
sudo apt-get update
sudo apt-get upgrade --fix-missing
sudo apt-get install vim fish build-essential automake pkg-config libevent-dev libncurses5-dev software-properties-common curl -y

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

#if uname -r | grep "Microsoft" -q;  then
  #if ! grep fish ~/.bashrc -q; then
    #cat $DIR/wsl.sh >> ~/.bashrc
  #fi
#else
  DEFAULT_SHELL=$(getent passwd $USER | cut -d: -f7)
  FISH_SHELL=$(which fish)
  if [ "$DEFAULT_SHELL" != "$FISH_SHELL" ]; then
    chsh -s $FISH_SHELL
  fi
#fi
