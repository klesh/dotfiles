sudo add-apt-repository ppa:fish-shell/release-3 -y
sudo apt update
sudo apt install fish -y

DEFAULT_SHELL=$(getent passwd $USER | cut -d: -f7)
FISH_SHELL=$(which fish)
if [ "$DEFAULT_SHELL" != "$FISH_SHELL" ]; then
chsh -s $FISH_SHELL
fi
