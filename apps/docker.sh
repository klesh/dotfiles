#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh


# install docker
case "$PM" in
    apt)
        sudo apt install -y docker.io docker-compose
        ! which pip3 && $ROOT/python/install.sh
        sudo pip3 install docker-compose
        ;;
    pacman)
        sudo pacman -S docker docker-compose
        ;;
esac

sudo systemctl enable docker
sudo systemctl start docker



# configuration
sudo usermod -aG docker $USER

if [ -d /etc/docker ]; then
    dj='{}'
    if [ -f /etc/docker/daemon.json ]; then
        # backup
        [ ! -f /etc/docker/daemon.bak.json ] && \
            sudo cp /etc/docker/daemon.json /etc/docker/daemon.bak.json
        # read
        dj=$(cat /etc/docker/daemon.json)
    fi
    echo $dj | jq '. + {"registry-mirrors": ["https://izuhlbap.mirror.aliyuncs.com"]}' | sudo tee /etc/docker/daemon.json
    sudo systemctl restart docker
fi
