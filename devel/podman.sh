#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"


# install docker
case "$PM" in
    apt)
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.opensuse.org/repositories/devel:kubic:libcontainers:unstable/xUbuntu_$(lsb_release -rs)/Release.key \
          | gpg --dearmor \
          | sudo tee /etc/apt/keyrings/devel_kubic_libcontainers_unstable.gpg > /dev/null
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/devel_kubic_libcontainers_unstable.gpg]\
            https://download.opensuse.org/repositories/devel:kubic:libcontainers:unstable/xUbuntu_$(lsb_release -rs)/ /" \
          | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:unstable.list > /dev/null
        sudo apt-get update -qq
        sudo apt-get -qq -y install podman podman-plugins dnsmasq netavark
        sudo pip install podman-compose
        ;;
    pacman)
        ;;
esac

# configuration
echo "
[network]

# Explicitly use netavark. See https://github.com/containers/podman-compose/issues/455
network_backend = "netavark"
" | sudo tee /etc/containers/containers.conf

