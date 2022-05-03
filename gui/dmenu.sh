#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up dmenu'

makeinstallrepo https://gitee.com/klesh/dmenu.git dmenu
