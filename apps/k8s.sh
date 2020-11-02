#!/bin/sh

DIR=$(readlink -f "$(dirname "$0")")
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
case "$DEFAULT_SHELL" in
    "$FISH")
        [ ! -f "$HOME/.config/fish/completions/docker.fish" ] && \
            curl -Lo "$HOME/.config/fish/completions/docker.fish" --create-dirs \
            'https://github.com/docker/cli/raw/master/contrib/completion/fish/docker.fish'
        fish -c "fisher add evanlucas/fish-kubectl-completions"
        ;;
esac
