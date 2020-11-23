#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"


# install cmark-gfm: convert markdown to html,man,xml,latex,comman-mark
case "$PM" in
    apt)
        sudo apt install -y cmark-gfm
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed cmark-gfm
        ;;
esac

# convert to html with embeded <style>: cmark-gfm input.md --to html --unsafe
