#!/bin/bash

set -e

DIR=$(dirname "${BASH_SOURCE[0]}")

echo '===================    Replace sources.list       ===================='
$DIR/install-sources.sh
echo '===================    Installing basic packages  ===================='
$DIR/install-base.sh
echo '===================    Installing fish shell      ===================='
$DIR/install-fish.sh
echo '===================    Installing nodejs          ===================='
$DIR/install-nodejs.sh
echo '===================    Installing vim             ===================='
$DIR/install-vim.sh
echo '===================    Installing tmux            ===================='
$DIR/install-tmux.sh
