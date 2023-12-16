

# wayland fractional scaling
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
echo set Ozone to wayland for browser to avoid blurry text
echo 1. google chrome: chrome://flags   -> preferred Ozone platform

gsettings set org.gnome.desktop.peripherals.mouse middle-click-emulation true
