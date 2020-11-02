#!/bin/sh


sudo systemctl disable systemd-networkd-wait-online
sudo systemctl mask systemd-networkd-wait-online
sudo systemctl disable cloud-init
sudo systemctl mask cloud-init
sudo systemctl disable cloud-config
sudo systemctl mask cloud-config
sudo systemctl disable gdm3
sudo systemctl mask gdm3
