#!/bin/sh

# shellcheck disable=2035

set -e

# print help if no arugment supplied
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

FONTPATH=$(readlink -f "$1")

# argument checking
STYLE=$2
case "$STYLE" in
    R|B|I|BI)
        ;;
    *)
        echo "warning: unknown style $STYLE, are u sure? [y/N]"
        read -r CONFIRM_STYLE
        if [ "$CONFIRM_STYLE" != 'y' ]; then
            exit
        fi
        ;;
esac
GROFF_CURRENT=$(readlink -f /usr/share/groff/current)
GROFF_SITEFONT=/usr/share/groff/site-font

# conversion
TMPDIR="$(mktemp -d)"
trap 'rm -rf '"$TMPDIR"';cd - >/dev/null' EXIT
cd "$TMPDIR"
echo "Change working directory to: $(pwd)"

echo "Using fontforge to generate PFA"
# fontforge do not process -c argument the same way as -script, have to create a temporary script
cat <<'EOT' > generate-pfa.pe
Open($1);
Generate($fontname + ".pfa");
EOT
fontforge -script generate-pfa.pe "$FONTPATH" >/dev/null 2>&1
AFM=$(ls *.afm)
PFA=$(ls *.pfa)
FONTNAME=$(awk '$1 == "FamilyName" {print substr($0, 12)}' "$AFM" | sed -r 's/\s+//g')
GROFFNAME=$FONTNAME$STYLE
echo "Converting to groff font"
afmtodit "$AFM" "$GROFF_CURRENT/font/devps/generate/textmap" "$GROFFNAME" >/dev/null 2>&1
INA=$(awk '$1 == "internalname" { print $2; exit; }' "$GROFFNAME")
echo "groff name    : $GROFFNAME"
echo "internalname  : $INA"

# installation
echo "Copying to $GROFF_SITEFONT"
sudo mkdir -p $GROFF_SITEFONT/devps
sudo mkdir -p $GROFF_SITEFONT/devpdf
sudo cp "$PFA" "$GROFFNAME" "$GROFF_SITEFONT/devps"
sudo ln -sf "$GROFF_SITEFONT/devps/$PFA" "$GROFF_SITEFONT/devpdf/$PFA"
sudo ln -sf "$GROFF_SITEFONT/devps/$GROFFNAME" "$GROFF_SITEFONT/devpdf/$GROFFNAME"

echo "Adding font to downloadable list"
if ! grep "$PFA" "$GROFF_CURRENT/font/devps/download" ; then
    printf '%s\t%s\n' "$INA" "$PFA" | sudo tee -a "$GROFF_CURRENT/font/devps/download" >/dev/null
fi
if ! grep "$PFA"  "$GROFF_CURRENT/font/devpdf/download" ; then
    printf '\t%s\t%s\n' "$INA" "$PFA" | sudo tee -a "$GROFF_CURRENT/font/devpdf/download" >/dev/null
fi

# print result and tips
echo
echo "Done, now you may use this font in your .mom file:"
printf "\033[32m"
echo " .class [cjk] \\[u4E00]-\\[u9FFF]"
echo " .class [puc] \\[u3000]-\\[u303F]"
echo " .cflags 66 \\C'[cjk]'"
echo " .cflags 68 \\C'[puc]'"
echo " .FAMILY $FONTNAME"
if [ "$STYLE" != "R" ] ; then
echo " .FONT $STYLE"
fi
printf "\033[0m"
echo
echo "Then, use following command to generate pdf file:"
printf "\033[32m"
echo " groff -mom -U -Kutf8 input.ms > /tmp/tmp.ps"
echo " ps2pdf /tmp/tmp.ps output.pdf"
printf "\033[0m"
echo
echo "PS: to insert image"
echo " imagemagick covert image: convert input.jpg output.eps"
echo " in .mom file use        : .PSPIC output.eps"
echo

