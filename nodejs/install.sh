#!/bin/bash

DIR=$(readlink -f $(dirname $0))
. $DIR/../env.sh


# install nodejs and yarn
case "$PM" in
    apt)
        sudo apt install -y nodejs yarnpkg
        ;;
    pacman)
        sudo pacman -S --needed nodejs yarn
        ;;
esac

# install nvm
if fish-is-default-shell; then
    fish -c "fisher add jorgebucaran/nvm.fish"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
fi


# config mirrors for CHINA
if in-china; then
    yarnpkg config set registry https://registry.npm.taobao.org --global  && \
    yarnpkg config set disturl https://npm.taobao.org/dist --global && \
    yarnpkg config set sass_binary_site https://npm.taobao.org/mirrors/node-sass --global  && \
    yarnpkg config set electron_mirror https://npm.taobao.org/mirrors/electron/ --global  && \
    yarnpkg config set puppeteer_download_host https://npm.taobao.org/mirrors --global  && \
    yarnpkg config set chromedriver_cdnurl https://npm.taobao.org/mirrors/chromedriver --global  && \
    yarnpkg config set operadriver_cdnurl https://npm.taobao.org/mirrors/operadriver --global  && \
    yarnpkg config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs --global  && \
    yarnpkg config set selenium_cdnurl https://npm.taobao.org/mirrors/selenium --global  && \
    yarnpkg config set sqlite3_binary_host_mirror "https://foxgis.oss-cn-shanghai.aliyuncs.com/" --global  && \
    yarnpkg config set profiler_binary_host_mirror "https://npm.taobao.org/mirrors/node-inspector/" --global  && \
    yarnpkg config set chromedriver_cdnurl "https://cdn.npm.taobao.org/dist/chromedriver" --global  && \
    yarnpkg config set node_inspector_cdnurl https://npm.taobao.org/mirrors/node-inspector --global && \
    yarnpkg config set sentrycli_cdnurl 'https://npm.taobao.org/mirrors/sentry-cli'
fi
