#!/bin/bash

if [ ! -e /etc/apt/sources.bak ]; then
  sudo mv /etc/apt/sources.list /etc/apt/sources.bak

  CURRENT_CODENAME=$(lsb_release -c | cut -f2)
  SOURCE_CODENAME=$(head -n 1 $DIR/sources.list | cut -d' ' -f3)
  if [ "$CURRENT_CODENAME" != "$SOURCE_CODENAME" ]; then
    sudo bash -c "cat $DIR/sources.list | sed s/$SOURCE_CODENAME/$CURRENT_CODENAME/g > /etc/apt/sources.list"
  else
    sudo cp $DIR/sources.list /etc/apt/
  fi
fi
