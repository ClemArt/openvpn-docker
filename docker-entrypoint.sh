#!/bin/sh
set -e

usage () {
  echo """Use one of
    generate <kind> [arguments]
        ca <name> - Generate root CA/Key for signing
        child-ca <name> <signing-ca> <signing-config> - Generate signed CA/Key for openvpn server/client
        dh <nbits> - Generate Diffie–Hellman key for secure TLS exchange
    start - Start the openvpn server
  """
}

PKI_GENERATION_VOLUME=/pki

if [ "$1" == "generate" ]; then
  shift
  cd $PKI_GENERATION_VOLUME

  if [ "$1" == "ca" ]; then
    cfssl genkey -initca $2.json | cfssljson -bare $2
    exit 0
  fi

  if [ "$1" == "child-ca" ]; then
    if [ -z "$3" ]; then
      echo "Missing signing CA (pem format)"
      usage
      exit 1
    fi

    if [ -z "$4" ]; then
      echo "Missing signing config (json format)"
      usage
      exit 1
    fi

    cfssl gencert -ca $3.pem -ca-key $3-key.pem \
      -config $4.json \
      $2.json | cfssljson -bare $2

    exit 0
  fi

  if [ "$1" == "dh" ]; then
    openssl dhparam -outform PEM -out dh.pem $2
    exit 0
  fi

  usage
  exit 0
fi

is_flag=0
case "$1" in
  -*) is_flag=1 ;;
esac

if [ "$1" == "start" ] || [ $is_flag -eq 1 ]; then
  [ "$1" == "--help" ] && exec openvpn --help && exit 0
  [ "$1" == "start" ] && shift

  # Copy keys to avoid permissions issues
  mkdir -p /ssl/pki
  cp /pki/* /ssl/pki/
  chmod -R 400 /ssl/pki


  # Create device
  mkdir -p /dev/net
  if [ ! -c /dev/net/tun ]; then
      mknod /dev/net/tun c 10 200
  fi

  # Check iptables capabilities
  iptables -L > /dev/null || {
    echo "Missing capability CAP_NET_ADMIN to administrate IP forwarding"
    exit 1
  }

  set -- openvpn "$@" "--script-security" "2" "--config" "/config/server.conf"

  echo "arguments $@"
fi

if [ "$1" == "help" ]; then
  usage && exit 0
fi

exec "$@"