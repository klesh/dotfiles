#!/bin/sh

set -e

if [ "$#" -lt 2 ] ;then
    echo "Remove files/directories which name contains DatePart and before n days ago"
    echo
    echo "  Usage $0 <dir> <days>"
    exit 1
fi

TARGET_DIR=${1%/}
THRES_DATE=$(date -d "$2 days ago" +%Y%m%d)

for entry in $(ls "$TARGET_DIR") ;do
    DATE=$(echo "$entry" | grep -oP '\b(\d{8})\b')
    if [ -n "DATE" ] && [ "$DATE" -lt "$THRES_DATE" ] ;then
        rm -f $TARGET_DIR/$entry
    fi
done
