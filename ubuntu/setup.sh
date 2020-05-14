#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")

$DIR/install-sources.sh
$DIR/install-base.sh
$DIR/install-fish.sh
$DIR/install-vim.sh
$DIR/install-tmux.sh
