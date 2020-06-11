#!/usr/bin/env fish

set DIR (dirname (dirname (readlink -f (status --current-filename))))

# cli basic tooling
pacman -S \
  base-devel \
  neovim \
  tmux bc \
  unzip p7zip \
  openssh \
  numlockx \
  axel \
  exfat-utils \
  man \
  sudo

# gui basic tooling
pacman -S \
  xorg-server xorg-xinit xorg-xrandr xorg-xev xorg-xbacklight xorg-xprop \
  xss-lock \
  xorg-xsetroot xdo xdotool \
  alsa-firmware alsa-utils alsa-plugins pulseaudio-alsa pulseaudio pavucontrol  \
  arandr autorandr \
  dunst \
  picom \
  xclip xsel \
  ibus ibus-table ibus-table-chinese
  #fcitx fcitx-configtool fcitx-gtk2 fcitx-gtk3 fcitx-qt5


# gui file manager
pacman -S \
  thunar gvfs-smb gvfs-mtp thunar-archive-plugin file-roller tumbler

# network manger
pacman -S \
  networkmanager network-manager-applet
systemctl enable NetworkManager
systemctl start NetworkManager

# keyring
pacman -S \
  gnome-keyring libsecret


# gui apps
pacman -S \
  #chromium \
  flameshot \
  keepassxc \
  libreoffice-fresh \
  gimp \
  nitrogen \
  alacritty \
  nextcloud-client \
  zathura zathura-pdf-mupdf sxiv\
  lxappearance arc-gtk-theme arc-icon-theme qt5ct qt5-styleplugins
# open qt5ct and set theme to gtk2


# fonts
pacman -S \
  terminus-font ttf-droid freetype2 ttf-cascadia-code ttf-dejavu wqy-microhei-lite \
  gucharmap

# media playing
pacman -S \
  mpd mpc ncmpcpp mpv

# bluetooth
pacman -S \
  bluez bluez-utils blueman pulseaudio-bluetooth
systemctl enable bluetooth
systemctl start bluetooth

# docker
pacman -S docker
mkdir -p /etc/docker
echo '{
  "registry-mirrors": ["https://izuhlbap.mirror.aliyuncs.com"]
}' > /etc/docker/daemon.json
systemctl enable docker
systemctl restart docker


# python
sudo pacman -S python python-pip
sudo cp -r $DIR/pip /root/.pip
sudo pip install ranger-fm ueberzug

