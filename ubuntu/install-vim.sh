#!/bin/bash

set -e

#sudo add-apt-repository ppa:jonathonf/vim -y
#sudo apt update
#sudo apt install -y vim

sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt-get update
sudo apt install -y neovim
