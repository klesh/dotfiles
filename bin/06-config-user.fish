#!/usr/bin/env fish

switch (uname)
case Darwin
  if not which greadlink 1>/dev/null 2>/dev/null
    brew install coreutils
  end
  set DIR (dirname (dirname (greadlink -e (status --current-filename))))
case '*'
  set DIR (dirname (dirname (readlink -f (status --current-filename))))
end

set DRYRUN 0

function run-cmd
  if [ "$DRYRUN" = "1" ]
    echo $argv
  else
    eval $argv
  end
end

function link-dotfolder
  echo making link to ~/.$argv
  run-cmd "mkdir -p ~/.$argv/"
  for i in (ls $DIR/$argv)
    if test -e ~/.$argv/$i
      run-cmd "rm -rf ~/.$argv/$i"
    end
    set CMD "ln -sf $DIR/$argv/$i ~/.$argv/"
    run-cmd $CMD
  end
end

function link-dotfile
  echo making link to ~/.$argv
  if test -e ~/.$argv
    run-cmd "rm -rf ~/.$argv"
  end
  run-cmd "ln -sf $DIR/$argv ~/.$argv"
end

set -l argv
argparse 'c/cli-only' -- $argv


link-dotfolder config
link-dotfolder pip
link-dotfile tmux.conf
#link-dotfile vimrc
rm -rf ~/.vimrc ~/.vim/coc-settings.json
ln -s $DIR/config/nvim/init.vim ~/.vimrc
mkdir -p ~/.vim
ln -s $DIR/config/nvim/coc-settings.json ~/.vim/coc-settings.json
# install tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if [ -n "$_flag_c" ]
  link-dotfile xinitrc
  link-dotfile Xresources
  #link-dotfile Xmodmap
  # set zathura as default pdf viewer
  xdg-mime default org.pwmt.zathura.desktop application/pdf


  # setup mpd
  mkdir -p ~/.mpd/playlists
  systemctl --user enable mpd
  systemctl --user start mpd

  # install ranger plugin
  yay -S ttf-nerd-fonts-symbols
  git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
end
