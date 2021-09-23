#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

if ! has_cmd go; then
    "$PDIR/devel/go.sh"
fi
log 'Setting up lf'

# install lf
if ! has_cmd "lf"; then
    env GOPROXY= CGO_ENABLED=0 GO111MODULE=on go get -u -ldflags="-s -w" github.com/gokcehan/lf
fi

# linking configuration files
lnsf "$DIR/lf/lfrc" "$XDG_CONFIG_HOME/lf/lfrc"
