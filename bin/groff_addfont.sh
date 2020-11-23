#!/bin/sh


set -e
# generate pfa

FONTPATH=$1
# with R B I suffix
GROFFNAME=$2

TMPDIR="$(mktemp -d)"
cd "$TMPDIR"

fontforge -c 'Open($1);Generate($fontname + ".pfa");' "$FONTPATH"
AFM=$(ls *.afm)
PFA=$(ls *.pfa)
afmtodit "$AFM" textmap "$GROFFNAME"
INA=$(awk '$1 == "internalname" { print $2; exit; }')
sudo mkdir -p /usr/share/groff/site-font/devps
#sudo mkdir -p /usr/share/groff/site-font/devpdf
sudo cp "$PFA" "$GROFFNAME" /usr/share/groff/site-font/devps
sudo ln -sf "/usr/share/groff/site-font/devps/$PFA" "/usr/share/groff/site-font/devpdf/$PFA"
#sudo ln -sf "/usr/share/groff/site-font/devps/$GROFFNAME" "/usr/share/groff/site-font/devpdf/$GROFFNAME"

GROFF_CURRENT=$(readlink -f /usr/share/groff/current)
if ! grep "$PFA" "$GROFF_CURRENT/font/devps/download" ; then
    printf '%s\t%s\n' "$INA" "$PFA" >>  "$GROFF_CURRENT/font/devps/download"
fi
#if ! grep "$PFA"  "$GROFF_CURRENT/font/devpdf/download" ; then
    #printf '\t%s\t%s\n' "$GROFFNAME" "$PFA" >> "$GROFF_CURRENT/font/devpdf/download"
#fi

cd -
rm -rf "$TMPDIR"

# groff -ms -U -Kutf8 input.ms > tmp.ps
# ps2pdf tmp.ps output.ms

# to insert picture: convert input.jpg output.pdf
# in msfile use: .PICPDF output.pdf
