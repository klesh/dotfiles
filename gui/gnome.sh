

# wayland fractional scaling
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

gsettings set org.gnome.desktop.peripherals.mouse middle-click-emulation true

# disable tapping super key to activate the gnome-shell-activies-overlay
gsettings set org.gnome.mutter overlay-key ""

# chromium: no ime support (gnome 45)
echo set Ozone to wayland for browser to avoid blurry text
echo 1. google chrome: chrome://flags   -> preferred Ozone platform
