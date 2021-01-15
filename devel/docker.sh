#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"


# install docker
case "$PM" in
    apt)
        # snap docker will intefere native docker.io, must be dealt with
        sudo snap remove --purge docker
        pm_update
        sudo apt install -y docker.io
        "$PDIR/devel/python.sh"
        sudo pip3 install docker-compose
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed docker docker-compose
        ;;
esac

sudo systemctl enable docker
sudo systemctl start docker

# configuration
sudo usermod -aG docker "$USER"

# set mirror for GREAT CHINA
if in_china; then
    sudo mkdir -p /etc/docker
    if [ -f /etc/docker/daemon.json ]; then
        # backup
        if [ ! -f /etc/docker/daemon.bak.json ]; then
            sudo cp /etc/docker/daemon.json /etc/docker/daemon.bak.json
        fi
        # read
        dj=$(cat /etc/docker/daemon.json)
    fi
    if [ -z "$dj" ]; then
        dj='{}'
    fi
    echo $dj | jq '. + {"registry-mirrors": ["https://izuhlbap.mirror.aliyuncs.com"]}' | \
        sudo tee /etc/docker/daemon.json
    sudo systemctl restart docker
fi
