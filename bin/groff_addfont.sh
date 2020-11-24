#!/bin/sh


set -e
# generate pfa

if [ "$#" -lt 2 ]; then
    CMD=$(basename "$0")
    echo "Usage: $CMD <*.ttf/ttc/otf> <style>"
    echo " regular      : $CMD sarasa-ui-sc-regular.ttf R"
    echo " italic       : $CMD sarasa-ui-sc-italic.ttf I"
    echo " bold         : $CMD sarasa-ui-sc-bold.ttf B"
    echo " bold italic  : $CMD sarasa-ui-sc-bolditalic.ttf BI"
    echo
    echo "note: the suffix of groff_name (R/I/B/BI) is essential!"
fi

DIR=$(dirname "$(readlink -f "$0")")
FONTPATH=$(readlink -f "$1")
# with R B I suffix
STYLE=$2
GROFF_CURRENT=$(readlink -f /usr/share/groff/current)
GROFF_SITEFONT=/usr/share/groff/site-font

TMPDIR="$(mktemp -d)"
trap 'rm -rf '"$TMPDIR"';cd -' EXIT
cd "$TMPDIR"
echo "Change working directory to: $(pwd)"

echo "Using fontforge to generate PFA"
fontforge -script "$DIR/generate-pfa.pe" "$FONTPATH" >/dev/null 2>&1
AFM=$(ls ./*.afm)
PFA=$(ls ./*.pfa)


FONTNAME=$(awk '$1 == "FamilyName" {print substr($0, 12)}' "$AFM" | sed -r 's/\s+//g')
GROFFNAME=$FONTNAME$STYLE
echo "Converting to groff font"
afmtodit "$AFM" "$GROFF_CURRENT/font/devps/generate/textmap" "$GROFFNAME" >/dev/null 2>&1
INA=$(awk '$1 == "internalname" { print $2; exit; }' "$GROFFNAME")
echo "groff name    : $GROFFNAME"
echo "internalname  : $INA"

echo "Copying to $GROFF_SITEFONT"
sudo mkdir -p $GROFF_SITEFONT/devps
sudo cp "$PFA" "$GROFFNAME" /usr/share/groff/site-font/devps

echo "Adding font to downloadable list"
if ! grep "$PFA" "$GROFF_CURRENT/font/devps/download" ; then
    printf '%s\t%s\n' "$INA" "$PFA" | sudo tee -a "$GROFF_CURRENT/font/devps/download" >/dev/null
fi

echo "Done, now you may use this font in your .ms file:"
echo " .ds FAM $FONTNAME"
echo
echo "Then, use following command to generate pdf file:"
echo " groff -ms -U -Kutf8 input.ms > tmp.ps"
echo " ps2pdf tmp.ps output.pdf"
echo

#sudo ln -sf "/usr/share/groff/site-font/devps/$PFA" "/usr/share/groff/site-font/devpdf/$PFA"
#sudo ln -sf "/usr/share/groff/site-font/devps/$GROFFNAME" "/usr/share/groff/site-font/devpdf/$GROFFNAME"

#if ! grep "$PFA"  "$GROFF_CURRENT/font/devpdf/download" ; then
    #printf '\t%s\t%s\n' "$GROFFNAME" "$PFA" >> "$GROFF_CURRENT/font/devpdf/download"
#fi

# to insert picture: convert input.jpg output.pdf
# in msfile use: .PICPDF output.pdf
