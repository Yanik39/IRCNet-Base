#!/bin/bash

set -e

cd /tmp
wget https://www.unrealircd.org/downloads/unrealircd-$UNREAL_VERSION.tar.gz{,.asc}
gpg --keyserver keyserver.ubuntu.com --recv-key 0xA7A21B0A108FF4A9
gpg --verify unrealircd-$UNREAL_VERSION.tar.gz.asc unrealircd-$UNREAL_VERSION.tar.gz
tar zxvf unrealircd-$UNREAL_VERSION.tar.gz -C /tmp
cd /tmp/unrealircd-$UNREAL_VERSION
expect /scripts/unrealircd.expect
make -j $(getconf _NPROCESSORS_ONLN)
make install
rm -rf /home/ircnet/UnrealIRCd/source
mv /home/ircnet/UnrealIRCd/conf /home/ircnet/UnrealIRCd/conf_default_configs
