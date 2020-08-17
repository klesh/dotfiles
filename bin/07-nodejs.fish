#!/usr/bin/env fish


sudo pacman -S nodejs yarn
yarnpkg config set registry https://registry.npm.taobao.org --global  && \
yarnpkg config set disturl https://npm.taobao.org/dist --global && \
yarnpkg config set sass_binary_site https://npm.taobao.org/mirrors/node-sass --global  && \
yarnpkg config set electron_mirror https://npm.taobao.org/mirrors/electron/ --global  && \
yarnpkg config set puppeteer_download_host https://npm.taobao.org/mirrors --global  && \
yarnpkg config set chromedriver_cdnurl https://npm.taobao.org/mirrors/chromedriver --global  && \
yarnpkg config set operadriver_cdnurl https://npm.taobao.org/mirrors/operadriver --global  && \
yarnpkg config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs --global  && \
yarnpkg config set selenium_cdnurl https://npm.taobao.org/mirrors/selenium --global  && \
yarnpkg config set node_inspector_cdnurl https://npm.taobao.org/mirrors/node-inspector --global
