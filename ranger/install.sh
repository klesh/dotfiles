#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

# install ranger
case "$PM" in
    apt)
        # atool/p7zip-full for archive previewing/extracting etc
        sudo apt install -y atool p7zip-full unrar highlight
        ! command -v pip3 && "$PDIR/python/install.sh"
        sudo pip3 install ranger-fm ueberzug
        ;;
    pacman)
        sudo pacman -S --needed atool p7zip unrar highlight
        sudo pip install ranger-fm ueberzug
        ;;
esac

# linking configuration files
lnsf "$DIR/config/commands.py" "$XDG_CONFIG_HOME/ranger/commands.py"
lnsf "$DIR/config/rc.conf" "$XDG_CONFIG_HOME/ranger/rc.conf"
lnsf "$DIR/config/scope.sh" "$XDG_CONFIG_HOME/ranger/scope.sh"
lnsf "$DIR/config/colorschemes/solarizedmod.py" "$XDG_CONFIG_HOME/ranger/colorschemes/solarizedmod.py"

# install devicons
[ ! -d ~/.config/ranger/plugins/ranger_devicons ] && \
    git clone --depth 1 https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
