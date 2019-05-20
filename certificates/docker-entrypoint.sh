#!/bin/bash
set -e

usage() {
  echo """Use one of
    ca <name>
    server-key <name> <master-ca>
    dh <nbits>
    client <name> <master-ca>
  """
}

if [ "$1" == "ca" ]; then
  cfssl genkey -initca /ssl/config/$2.json | cfssljson -bare $2
  exit 0
fi

if [ "$1" == "server-key" ]; then
  if [ -z "$3" ]; then
    usage
    exit 1
  fi

  cfssl gencert -ca $3.pem -ca-key $3-key.pem \
    -config /ssl/config/root-signing-config.json \
    /ssl/config/$2.json | cfssljson -bare $2
  exit 0
fi

if [ "$1" == "dh" ]; then
  openssl dhparam -outform PEM -out dh.pem $2
  exit 0
fi

if [ "$1" == "client" ]; then
  cfssl gencert -ca $3.pem -ca-key $3-key.pem \
    -config /ssl/config/root-signing-config.json \
    /ssl/config/$2.json | cfssljson -bare $2
  exit 0
fi

usage
