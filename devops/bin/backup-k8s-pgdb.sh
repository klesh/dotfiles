#!/bin/sh

set -e

if [ "$#" -lt 3 ] ;then
    echo "Keep recent N-days backup of postgres on k8s container"
    echo
    echo "  Usage $0 <days> <path/to/backup/directory> <pod-app-label> [container-name] [DBN]"
    exit 1
fi

DIR=$(dirname "$(readlink -f "$0")")
DAY=$1
BKD=$2
shift
shift

echo "start backing up on $(date)"
"$DIR/k8s-pgdball.sh" backup "$BKD/$(date +%Y%m%d)" "$@"
echo "start removing older archives"
"$DIR/rm-ndays-ago.sh" "$BKD" "$DAY"
echo "done!"
