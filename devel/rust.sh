#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log "Setting up rust"

if in_china; then
    export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
    export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

    if has_cmd fish >/dev/null; then
        echo "
            set -x RUSTUP_DIST_SERVER $RUSTUP_DIST_SERVER
            set -x RUSTUP_UPDATE_ROOT $RUSTUP_UPDATE_ROOT
        " | sed 's/^ *//' > "$XDG_CONFIG_HOME/fish/conf.d/rustup.fish"

    fi

    # setup cargo mirrors
    if [ ! -f "$HOME/.cargo/config" ]; then
        mkdir -p "$HOME/.cargo"
        echo "
            [source.crates-io]
            replace-with = 'ustc'

            [source.ustc]
            registry = \"git://mirrors.ustc.edu.cn/crates.io-index\"
        " | sed 's/^ *//' > "$HOME/.cargo/config"
    fi
fi

if [ ! -f "$HOME/.cargo/bin/rustup" ]; then
    curl -sSf https://cdn.jsdelivr.net/gh/rust-lang-nursery/rustup.rs/rustup-init.sh | sh
fi

echo "Please add follow line to your .profile"
echo 'export PATH=$HOME/.cargo/env:$PATH'

if has_cmd code; then
    echo "install following extension for VSCode debugging:"
    echo "  rust"
    echo "  codelldb"
fi

# coc.nvim
if enhance_vim; then
    rustup component add rls rust-analysis rust-src
    v -c "CocInstall -sync coc-rls|qall"
fi
