#!/bin/sh

if [ -z "$*" ] ;then
    echo "Usage: $0 <video-url>"
    exit 1
fi

if ! command -v yt-dlp 1>/dev/null 2>&1 ;then
    sudo pip install yt-dlp
fi

#
# TheFrenchGhosty's Ultimate YouTube-DL Scripts Collection: The ultimate collection of scripts for YouTube-DL
# https://github.com/TheFrenchGhosty/TheFrenchGhostys-Ultimate-YouTube-DL-Scripts-Collection
# https://github.com/TheFrenchGhosty
#
#
    #--output "%(title)s - %(uploader)s - %(upload_date)s/%(title)s - %(uploader)s - %(upload_date)s [%(id)s].%(ext)s" \

yt-dlp \
    --format "(bestaudio[acodec^=opus]/bestaudio)/best" \
    --verbose \
    --force-ipv4 \
    --sleep-interval 5 \
    --max-sleep-interval 30 \
    --ignore-errors \
    --no-continue \
    --no-overwrites \
    --download-archive archive.log \
    --add-metadata \
    --write-description \
    --write-info-json \
    --write-annotations \
    --write-thumbnail \
    --embed-thumbnail \
    --extract-audio \
    --match-filter "!is_live & !live" \
    --output "%(uploader)s - %(title)s.%(ext)s" \
    --merge-output-format "mkv" \
    "$@" 2>/tmp/download-yt-audio-error.log
