#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

timedatectl set-ntp on
. "$DIR/mirrors.sh"
. "$DIR/fish.sh"
. "$DIR/vim.sh"
. "$DIR/ranger.sh"
. "$DIR/tmux.sh"
