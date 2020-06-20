#!/bin/bash

set -e
sudo apt update
sudo apt upgrade --fix-missing -y -q
sudo apt install build-essential automake pkg-config software-properties-common curl -y -q
