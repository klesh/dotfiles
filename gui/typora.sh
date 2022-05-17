#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up typora'

lnsf "$DIR/typora/typora.desktop" ~/.local/share/applications/typora.desktop