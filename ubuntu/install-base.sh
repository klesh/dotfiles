#!/bin/bash

sudo apt update
sudo apt upgrade --fix-missing
sudo apt install fish build-essential automake pkg-config libevent-dev libncurses5-dev software-properties-common curl -y
