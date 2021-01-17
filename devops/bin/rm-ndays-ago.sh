#!/bin/sh

set -e

if [ "$#" -lt 2 ] ;then
    echo "Remove files/directories which name contains DatePart and before n days ago"
    echo
    echo "  Usage $0 <dir> <days>"
    exit 1
fi

TARGET_DIR=${1%/}
THRES_DATE=$(date -D "%S" -d $(( $(date +%s) - $2 * 24 * 3600 ))"" +%Y%m%d)

echo date prior to $THRES_DATE will be deleted
for entry in $(ls "$TARGET_DIR") ;do
    DATE=$(echo "$entry" | grep -oE '[0-9]{8}')
    if [ -n "DATE" ] && [ "$DATE" -lt "$THRES_DATE" ] ;then
        echo removeing $TARGET_DIR/$entry
        rm -rf $TARGET_DIR/$entry
    fi
done
