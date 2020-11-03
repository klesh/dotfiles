#!/bin/sh

DIR=$(readlink -f "$(dirname "$0")")
. "$DIR/../env.sh"

[ -z "$1" ] && echo Usage: $0 path/to/nerdfont.git/bin/scrips/lib && exit 1

awk '/i=/ { print substr($1, 4, 1), substr($2, 0, index($2, "=") - 1) }' \
    $1/i_{dev,fa,fae,iec,linux,material,oct,ple,pom,seti,weather}.sh > ~/.cache/icons

