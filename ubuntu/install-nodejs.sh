#!/bin/bash

set -e

[ ! -f /tmp/node.tar.xz ] && curl -L  https://nodejs.org/dist/v12.18.2/node-v12.18.2-linux-x64.tar.xz -o /tmp/node.tar.xz
rm -rf /tmp/node
mkdir -p /tmp/node
tar xf /tmp/node.tar.xz --strip 1 -C /tmp/node
pushd /tmp/node
sudo cp -r bin include lib share /usr/local
popd
rm -rf /tmp/node*
sudo apt install yarnpkg
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
yarnpkg config set node_inspector_cdnurl https://npm.taobao.org/mirrors/node-inspector --global
