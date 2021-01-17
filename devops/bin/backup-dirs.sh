#!/bin/sh

set -e

if [ "$#" -lt 2 ] ;then
    echo "Keep N days backup of a directory"
    echo
    echo "  Usage $0 <days> <backup-dir> <src-dir ...>"
    exit 1
fi

DIR=$(dirname "$(readlink -f "$0")")
DAY=$1
BKD=${2%/}
PTH=$BKD/$(date +%Y%m%d)
shift
shift

echo "start backing up on $(date)"
mkdir -p $PTH
while [ "$#" -gt 0 ] ;do
    SRC=$1
    echo "  backing up $SRC"
    tar -zcf "$PTH/$(basename $SRC).tar.gz" "$SRC"
    shift
done

echo "start removing older archives"
"$DIR/rm-ndays-ago.sh" "$BKD" "$DAY"

echo "done!"
