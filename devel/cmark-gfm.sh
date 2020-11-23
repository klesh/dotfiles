#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"


# install cmark-gfm: convert markdown to html,man,xml,latex,comman-mark
case "$PM" in
    apt)
        sudo apt install -y cmark-gfm entr
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed cmark-gfm entr
        ;;
esac

# live server for html previewing
"$PDIR/devel/nodejs.sh"
if in_china; then
    sudo cnpm install -g live-server
else
    sudo npm install -g live-server
fi
# convert to html with embeded <style>: cmark-gfm input.md --to html --unsafe > /path/to/output.html
# entr watch input.md and rerun convert command
# live-server to observe html file and reload browser

