#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

# install asdf, a multi-lang version manager
if ! has_cmd "asdf"; then
    git_clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
    mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    asdf plugin add nodejs
    asdf install nodejs latest
    asdf global nodejs latest
fi
