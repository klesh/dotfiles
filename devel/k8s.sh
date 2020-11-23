#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"


# install docker
case "$PM" in
    apt)
        #sudo snap install kubectl --classic
        ;;
    pacman)
        # TODO
        ;;
esac

# completion for fish
if has_cmd fish 2>/dev/null ; then
    if [ ! -f "$HOME/.config/fish/completions/docker.fish" ]; then
        curl -Lo "$HOME/.config/fish/completions/docker.fish" --create-dirs \
        'https://github.com/docker/cli/raw/master/contrib/completion/fish/docker.fish'
    fi
    fish -c "fisher add evanlucas/fish-kubectl-completions"
fi
