#!/bin/bash

set -e

ATHEME_VERSION=$(curl -s https://atheme.github.io/atheme.html | grep current | sed "s/.*\">//g" | sed "s/<\/.*//g")

cd /tmp
wget https://github.com/atheme/atheme/releases/download/v${ATHEME_VERSION}/atheme-services-v${ATHEME_VERSION}.tar.xz
tar xf atheme-services-v${ATHEME_VERSION}.tar.xz -C /tmp
cd /tmp/atheme-services-v${ATHEME_VERSION}
./configure --prefix=/home/ircnet/Atheme-Services --enable-contrib --enable-nls
make
make install
mv /home/ircnet/Atheme-Services/etc /home/ircnet/Atheme-Services/etc_default_configs
