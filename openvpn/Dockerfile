FROM alpine:3.9.4

LABEL maintainer=ClemArt

RUN apk add openvpn iptables

COPY ./docker-entrypoint.sh /

EXPOSE 11940/udp

ENTRYPOINT [ "/docker-entrypoint.sh" ]

VOLUME /pki
VOLUME /config

CMD [ "--script-security", "2", "--config", "/config/server.conf" ]
