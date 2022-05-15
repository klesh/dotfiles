#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up drawio'

echo download AppImage from github and save to ~/.local/bin
xdg-open "https://github.com/jgraph/drawio-desktop/releases"

echo download icon from github and save to ~/.local/share/icons/drawio.svg
xdg-open "https://github.com/jgraph/drawio-desktop/blob/dev/build/icon.svg"


lnsf "$DIR/drawio/drawio.desktop" ~/.local/share/applications/drawio.desktop
