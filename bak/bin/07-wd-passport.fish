#!/usr/bin/env fish

sudo pacman -Sy python2-pip lsscsi
sudo pip2 install py_sg

mkdir -p ~/Programs/bin
curl -L https://github.com/0-duke/wdpassport-utils/raw/master/wdpassport-utils.py | sed 's/python/python2/' \
  > ~/Programs/bin/wdpassport-utils
chmod +x ~/Programs/bin/wdpassport-utils
