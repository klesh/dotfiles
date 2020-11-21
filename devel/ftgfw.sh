#!/bin/sh


if [ ! -f /tmp/docker.zip ]; then
    echo "Please enter nextcloud hostname:"
    read -r HOSTNAME

    echo "Please enter nextcloud account:"
    read -r ACCOUNT

    echo "Please enter nextcloud password:"
    stty -echo
    read -r PASSWORD
    stty echo

    curl -u "$ACCOUNT:$PASSWORD" -Lo /tmp/docker.zip "https://$HOSTNAME:8443/index.php/apps/files/ajax/download.php?dir=%2F&files=docker"
fi

DEST_DIR=$HOME/Nextcloud
mkdir -p "$DEST_DIR"
7z x -o"$DEST_DIR" /tmp/docker.zip

