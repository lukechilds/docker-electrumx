FROM python:3.6-alpine3.6
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

COPY ./VERSION /tmp

RUN VERSION=$(cat /tmp/VERSION) && \
    chmod a+x /usr/local/bin/* && \
    apk add --no-cache git build-base && \
    apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing leveldb-dev && \
    pip install aiohttp pylru plyvel && \
    git clone https://github.com/lukechilds/electrumx.git && \
    cd electrumx && \
    python setup.py install && \
    apk del git build-base && \
    rm -rf /tmp/*

VOLUME ["/data"]
ENV HOME /data
ENV ALLOW_ROOT 1
ENV DB_DIRECTORY /data
WORKDIR /data

EXPOSE 50001 50002

CMD ["/electrumx/electrumx_server.py"]
