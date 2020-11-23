#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

if ! has_cmd python
    . "$PDIR/devel/python.sh"
fi
log 'Setting up ranger'

# install ranger
case "$PM" in
    apt)
        # atool/p7zip-full for archive previewing/extracting etc
        sudo apt install -y atool p7zip-full unrar
        sudo pip3 install ranger-fm ueberzug
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed atool p7zip unrar
        sudo pip install ranger-fm ueberzug
        ;;
esac

# linking configuration files
lnsf "$DIR/ranger/commands.py" "$XDG_CONFIG_HOME/ranger/commands.py"
lnsf "$DIR/ranger/rc.conf" "$XDG_CONFIG_HOME/ranger/rc.conf"
lnsf "$DIR/ranger/scope.sh" "$XDG_CONFIG_HOME/ranger/scope.sh"
lnsf "$DIR/ranger/colorschemes/solarizedmod.py" "$XDG_CONFIG_HOME/ranger/colorschemes/solarizedmod.py"

# install devicons
DEVICONS_DIR=$HOME/.config/ranger/plugins/ranger_devicons
if [ ! -d "$DEVICONS_DIR" ]; then
    git_clone https://gitee.com/klesh/ranger_devicons.git "$DEVICONS_DIR"
fi
