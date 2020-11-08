#!/bin/sh

set -e

# install python3.8
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.8

# install pip and other distutils
sudo apt install python3.8-distutils
sudo python3.8 -m pip install --upgrade pip setuptools wheel
