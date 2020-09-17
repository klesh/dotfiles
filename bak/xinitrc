export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

/*export XMODIFIERS="@im=fcitx"*/
/*export QT_IM_MODULE=fcitx*/
/*export GTK_IM_MODULE=fcitx*/
export XMODIFIERS="@im=ibus"
export QT_IM_MODULE=ibus
export GTK_IM_MODULE=ibus



# xrandr --setprovideroutputsource modesetting NVIDIA-0
# xrandr --auto

# make alacritty ignoring Xft.dpi setting
export WINIT_DPI_FACTOR=0

xrdb ~/.Xresources

xset s 300
# systemd-lock-handler $HOME/.config/i3/lock.sh
systemd-lock-handler /usr/local/bin/slock

xsetroot -cursor_name left_ptr

dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
# exec i3
# exec bspwm
# exec dwm

# exec ~/.config/dwm/launch.fish
autorandr --change --force
while :; do
	ssh-agent dwm 2>/tmp/dwm.log || break
done
