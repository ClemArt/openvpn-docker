FROM ubuntu:18.04

RUN apt update && \
    apt install -y make

VOLUME /workspace

WORKDIR /workspace

ENTRYPOINT [ "make" ]

CMD [ "all" ]