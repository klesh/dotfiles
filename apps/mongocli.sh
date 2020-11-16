#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"


# install mongodb-cli tools only
case "$PM" in
    apt)
        sudo apt install mongodb-clients
        ;;
    pacman)
        # TODO
        ;;
esac
