#!/usr/bin/env fish

if not type yay 1>/dev/null 2>/dev/null
  git clone https://aur.archlinux.org/yay.git ~/.yay
  cd ~/.yay
  makepkg -si
end

# ttf-symbola-free: st might crash if emoji font inexists when rendering

yay -S \
  google-chrome \
  fcitx-skins \
  ttf-nerd-fonts-symbols \
  autojump

# for feh
yay -S  ttf-consolas-with-yahei-powerline-git
