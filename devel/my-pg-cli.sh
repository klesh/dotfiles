#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"
"$PDIR/devel/python.sh"

sudo pip install mycli
sudo pip install pgcli
