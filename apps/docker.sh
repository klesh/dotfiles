#!/bin/sh

DIR=$(readlink -f "$(dirname "$0")")
. "$DIR/../env.sh"


# install docker
case "$PM" in
    apt)
        # snap docker will intefere native docker.io, must be dealt with
        sudo snap remove --purge docker
        sudo apt install -y docker.io docker-compose
        ! command -v pip3 && "$PDIR/python/install.sh"
        sudo pip3 install docker-compose
        ;;
    pacman)
        sudo pacman -S --needed docker docker-compose
        ;;
esac

sudo systemctl enable docker
sudo systemctl start docker



# configuration
sudo usermod -aG docker "$USER"

# completion
case "$DEFAULT_SHELL" in
    $FISH)
        curl -sLo "$HOME/.config/fish/completions/docker.fish" --create-dirs \
            'https://github.com/docker/cli/raw/master/contrib/completion/fish/docker.fish'
        ;;
esac

# set mirror
if in_china && [ -d /etc/docker ]; then
    if [ -f /etc/docker/daemon.json ]; then
        # backup
        [ ! -f /etc/docker/daemon.bak.json ] && \
            sudo cp /etc/docker/daemon.json /etc/docker/daemon.bak.json
        # read
        dj=$(cat /etc/docker/daemon.json)
    fi
    [ -z "$dj" ] && dj='{}'
    echo $dj | jq '. + {"registry-mirrors": ["https://izuhlbap.mirror.aliyuncs.com"]}' | \
        sudo tee /etc/docker/daemon.json
    sudo systemctl restart docker
fi
