#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"


FILES_PATH=$PREFIX/nodejs
NODE_BIN=$PREFIX/bin/node
NODE_URL=https://nodejs.org/dist
NODE_VERSION=v14.15.4
NPM_BIN=npm
if in_china; then
    NODE_URL=https://npm.taobao.org/mirrors/node
    NPM_BIN=cnpm
fi
export NPM_BIN

log "Setting up nodejs"

lspkgs() {
    curl -s $NODE_URL/index.json \
        | jq '.[] | "\(.version) \(if .lts then "(lts)" else "" end)"' -r
}

uninstall() {
    if [ -f "$FILES_PATH"  ]; then
        tac "$FILES_PATH" | grep -v '/$' | xargs -n 10 -- sudo rm -f
    fi
}

install() {
    VERSION=$1
    ARCH=x86
    if [ -x "$NODE_BIN" ] && [ "$("$NODE_BIN" --version)" = "$VERSION" ]; then
        return
    fi
    case "$(uname -m)" in
        x86_64)
            ARCH=x64
            ;;
        armv6|armv6l)
            ARCH=armv6l
            ;;
        armv7|armv7l)
            ARCH=armv7l
            ;;
        armv8|armv8l|aarch64)
            ARCH=arm64
            ;;
    esac
    NAME=node-$VERSION-linux-$ARCH.tar.gz
    # download package
    echo wget -O "/tmp/$NAME" "$NODE_URL/$VERSION/$NAME"
    wget -O "/tmp/$NAME" "$NODE_URL/$VERSION/$NAME"
    # remove previous installed
    uninstall
    # install and save extracted paths
    sudo tar zxvf "/tmp/$NAME" --strip 1 -C "$PREFIX" \
        | sed -r "s|^[^/]+/|$PREFIX/|" \
        | sudo tee "$FILES_PATH" >/dev/null
    # remove download path
    rm "/tmp/$NAME"
    sudo npm install -g yarn
    if in_china; then
        #sudo npm install -g cnpm --registry=https://registry.npm.taobao.org
        yarnpkg config set registry https://registry.npm.taobao.org --global
        yarnpkg config set disturl https://npm.taobao.org/dist --global
        yarnpkg config set sass_binary_site https://npm.taobao.org/mirrors/node-sass --global
        yarnpkg config set electron_mirror https://npm.taobao.org/mirrors/electron/ --global
        yarnpkg config set puppeteer_download_host https://npm.taobao.org/mirrors --global
        yarnpkg config set chromedriver_cdnurl https://npm.taobao.org/mirrors/chromedriver --global
        yarnpkg config set operadriver_cdnurl https://npm.taobao.org/mirrors/operadriver --global
        yarnpkg config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs --global
        yarnpkg config set selenium_cdnurl https://npm.taobao.org/mirrors/selenium --global
        yarnpkg config set sqlite3_binary_host_mirror https://foxgis.oss-cn-shanghai.aliyuncs.com/ --global
        yarnpkg config set profiler_binary_host_mirror https://npm.taobao.org/mirrors/node-inspector/ --global
        yarnpkg config set chromedriver_cdnurl https://cdn.npm.taobao.org/dist/chromedriver --global
        yarnpkg config set node_inspector_cdnurl https://npm.taobao.org/mirrors/node-inspector --global
        yarnpkg config set sentrycli_cdnurl https://npm.taobao.org/mirrors/sentry-cli
    fi
    if enhance_vim; then
        v -c "CocInstall -sync coc-json coc-vetur coc-tsserver coc-eslint|qall"
    fi
}


case "$1" in
    ls|list)
        lspkgs | less
        ;;
    uninstall)
        uninstall
        ;;
    '')
        install "$NODE_VERSION"
        ;;
    *)
        install "$1"
        ;;
esac


