#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up dict.sh'

makeinstallrepo https://github.com/klesh/dict.sh.git dict.sh
