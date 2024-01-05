#!/bin/sh

# applicable for wayland
# https://wayland.freedesktop.org/libinput/doc/1.11.3/udev_config.html#hwdb

sudo cp 90-trackball-btns.hwdb /etc/udev/hwdb.d

# to compile plain-text hwdb configuration into binary
sudo udevadm hwdb --update

# to find out event path:
sudo evtest

# to apply the hwdb configuration
sudo udevadm trigger /sys/class/input/eventX
