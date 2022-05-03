#!/bin/sh
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up slock'

makeinstallrepo https://gitee.com/klesh/slock.git slock
