#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log "Setting up rust"

if in_china; then
    export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
    export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

    if command -v fish >/dev/null; then
        echo "
            set -x RUSTUP_DIST_SERVER $RUSTUP_DIST_SERVER
            set -x RUSTUP_UPDATE_ROOT $RUSTUP_UPDATE_ROOT
        " | sed 's/^ *//' > "$XDG_CONFIG_HOME/fish/conf.d/rustup.fish"

    fi

    # setup cargo mirrors
    [ ! -f "$HOME/.cargo/config" ] && mkdir -p "$HOME/.cargo" && echo "
        [source.crates-io]
        replace-with = 'ustc'

        [source.ustc]
        registry = \"git://mirrors.ustc.edu.cn/crates.io-index\"
    " | sed 's/^ *//' > "$HOME/.cargo/config"
fi

[ ! -f "$HOME/.cargo/bin/rustup" ] \
    && curl -sSf https://cdn.jsdelivr.net/gh/rust-lang-nursery/rustup.rs/rustup-init.sh | sh

command -v fish >/dev/null && echo "
    source $HOME/.cargo/env
" | sed 's/^ *//' > "$XDG_CONFIG_HOME/fish/conf.d/cargo.fish"
