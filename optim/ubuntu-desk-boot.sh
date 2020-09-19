#!/bin/bash


sudo systemctl disable systemd-networkd-wait-online
sudo systemctl disable cloud-init
sudo systemctl disable cloud-config
sudo systemctl disable gdm3
