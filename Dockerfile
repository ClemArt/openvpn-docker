FROM alpine:3.9.4

LABEL maintainer=ClemArt

RUN apk add openvpn iptables curl openssl
#ca-certificates
RUN curl -L https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -o /usr/bin/cfssl && \
    curl -L https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -o /usr/bin/cfssljson && \
    chmod +x /usr/bin/cfssl*

COPY ./docker-entrypoint.sh /

EXPOSE 11940/udp

ENTRYPOINT [ "/docker-entrypoint.sh" ]

VOLUME /pki
VOLUME /config

CMD [ "start" ]
