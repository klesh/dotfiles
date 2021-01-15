#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

sudo timedatectl set-ntp on
. "$DIR/mirrors.sh"
. "$DIR/basic.sh"
. "$DIR/fish.sh"
. "$DIR/vim.sh"
. "$DIR/tmux.sh"
. "$DIR/ranger.sh"
