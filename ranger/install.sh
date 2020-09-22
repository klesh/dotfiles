#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh

# install ranger
case "$PM" in
    apt)
        # atool/p7zip-full for archive previewing/extracting etc
        sudo apt install -y atool p7zip-full
        ! which pip3 && $ROOT/python/install.sh
        sudo pip3 install ranger-fm ueberzug
        ;;
    pacman)
        sudo pip install ranger-fm ueberzug atool p7zip
        ;;
esac

# linking configuration files
lnsf $DIR/config/commands.py $XDG_CONFIG_HOME/ranger/commands.py
lnsf $DIR/config/rc.conf $XDG_CONFIG_HOME/ranger/rc.conf
lnsf $DIR/config/scope.sh $XDG_CONFIG_HOME/ranger/scope.sh

# install devicons
git clone --depth 1 https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
