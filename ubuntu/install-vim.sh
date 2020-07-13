#!/bin/bash

set -e

sudo add-apt-repository ppa:jonathonf/vim -y
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt update
sudo apt install -y vim
sudo apt install -y neovim
