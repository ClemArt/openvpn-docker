FROM ubuntu:18.04

RUN apt update && apt install -y curl

RUN curl -L https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -o /usr/bin/cfssl && \
    curl -L https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 -o /usr/bin/cfssljson && \
    chmod +x /usr/bin/cfssl*

COPY ./docker-entrypoint.sh /

WORKDIR /ssl/pki

VOLUME /ssl/pki
VOLUME /ssl/config

ENTRYPOINT [ "/docker-entrypoint.sh" ]