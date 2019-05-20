#!/bin/sh
set -e

mkdir -p /ssl/pki
cp /pki/* /ssl/pki/
chmod -R 400 /ssl/pki

mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

if [ "$1" != "sh" ]; then
  set -- openvpn "$@"
fi

exec "$@"