#!/bin/bash


# install dependencies
sudo apt install build-essential xorg libx11-dev libxft-dev libxinerama-dev trayer

mkdir -p ~/Projects/suckless

git clone https://gitee.com/klesh/st.git ~/Projects/suckless/st
cd ~/Projects/suckless/st && sudo rm -f config.h && sudo make clean install

git clone https://gitee.com/klesh/dmenu.git ~/Projects/suckless/dmenu
cd ~/Projects/suckless/dmenu && sudo rm -f config.h && sudo make clean install

git clone https://gitee.com/klesh/slock.git ~/Projects/suckless/slock
cd ~/Projects/suckless/slock && sudo rm -f config.h && sudo make clean install

git clone https://gitee.com/klesh/dwm.git ~/Projects/suckless/dwm
cd ~/Projects/suckless/dwm && sudo rm -f config.h && sudo make clean install
