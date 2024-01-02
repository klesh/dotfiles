# enable wayland fractional scaling
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

# tap left/right buttons at the same time to mimic middle click
gsettings set org.gnome.desktop.peripherals.mouse middle-click-emulation true

# disable tapping super key to activate the gnome-shell-activies-overlay
gsettings set org.gnome.mutter overlay-key ""

gsettings set org.gnome.desktop.wm.keybindings minimize []

echo
echo install fcitx5 which can also enter emoji by pressing "super+;", and "ctrl+u" for a clipboard history
sudo apt install fcitx5 fcitx5-table fcitx5-skin-nord

echo
echo chromium: no ime support yet (up to gnome 45), use Firefox instead
echo set Ozone to wayland for browser to avoid blurry text
echo 1. google chrome: chrome://flags   -> preferred Ozone platform

echo
echo auto unlock keyring with luks/auto-login
echo '1. change the keyring unlock password to some simple text, e.g. somepass'
echo '   launch keyring, right click the "Login" on the right side bar and'
echo '   then "Change Password"'
echo '2. auto unlock the keyring on login:'
echo '   echo -n "somepass" | gnome-keyring-daemon –unlock'

echo
echo enable Wayland support for Firefox
echo add MOZ_ENABLE_WAYLAND=1 to /etc/environment and reboot

echo
echo recommended plugin
echo 'appindicatorsupport@rgcjonas.gmail.com'/  'no-overview@fthx'/            'search-light@icedman.github.com'/
echo 'dash-to-dock@micxgx.gmail.com'/           'paperwm@paperwm.github.com'/  'Vitals@CoreCoding.com'/


