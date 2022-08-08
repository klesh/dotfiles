#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up drawio'

echo download AppImage from github and save to ~/.local/bin
xdg-open "https://github.com/jgraph/drawio-desktop/releases"

echo download icon from github and save to ~/.local/share/icons/drawio.svg
xdg-open "https://github.com/jgraph/drawio-desktop/blob/dev/build/icon.svg"


cat <<MIME > ~/.local/share/mime/packages/drawio.xml
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    <mime-type type="application/vnd.jgraph.mxfile">
        <comment>Drawio Diagram</comment>
        <glob pattern="*.drawio" case-sensitive="true"/>
    </mime-type>
</mime-info>
MIME

lnsf "$DIR/drawio/drawio.desktop" ~/.local/share/applications/drawio.desktop

update-mime-database ~/.local/share/mime
