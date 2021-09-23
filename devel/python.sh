#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log "Setting up python3"

if in_china; then

    # config pip mirror for CHINA
    echo "
    [global]
    index-url = https://mirrors.aliyun.com/pypi/simple
    " | sed -r 's/^ *//' | sudo tee "/etc/pip.conf"
fi

# install python3
case "$PM" in
    apt)
        #for older ubuntu distro
        #sudo add-apt-repository ppa:deadsnakes/ppa
        #sudo apt-get update
        #sudo apt-get install python3.8
        #sudo apt install python3.8-distutils
        #sudo python3.8 -m pip install --upgrade pip setuptools wheel
        sudo apt install -y python3 python3-pip python-is-python3
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed python python-pip
        ;;
esac

# enable auto_activation plugin for virtualfish
if has_fish; then
    sudo pip install virtualfish
    fish -c "yes | vf install && vf addplugins auto_activation"
fi

# config flake8
lnsf "$DIR/python/flake8" "$XDG_CONFIG_HOME/flake8"
