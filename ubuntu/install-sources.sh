#!/bin/bash

set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
ARCH=$(lscpu | head -n 1 | awk '{print $2}')
if [ ! -e /etc/apt/sources.bak ]; then
  sudo mv /etc/apt/sources.list /etc/apt/sources.bak

  CURRENT_CODENAME=$(lsb_release -c | cut -f2)
  SOURCE_CODENAME=$(head -n 1 $DIR/sources.$ARCH.list | cut -d' ' -f3)
  sudo bash -c "sed s/$SOURCE_CODENAME/$CURRENT_CODENAME/g $DIR/sources.$ARCH.list > /etc/apt/sources.list"
fi

# pip mirrors
mkdir -p $HOME/.pip
cat <<EOF > $HOME/.pip/pip.conf
[global]
#trusted-host =  mirrors.aliyun.com
#index-url = https://mirrors.aliyun.com/pypi/simple
index-url = https://pypi.doubanio.com/simple
trusted-host = pypi.doubanio.com
EOF

# docker accelerator
if [ -d /etc/docker ]; then
  dj='{}'
  [ -f /etc/docker/daemon.json ] && dj=$(cat /etc/docker/daemon.json)
  echo $dj | jq '. + {"registry-mirrors": ["https://izuhlbap.mirror.aliyuncs.com"]}' > /etc/docker/daemon.json
  systemctl restart docker
fi
