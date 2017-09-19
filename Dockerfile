FROM python:3.6-alpine3.6
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

VOLUME ["/data"]

COPY ./VERSION /tmp

RUN VERSION=$(cat /tmp/VERSION) && \
    chmod a+x /usr/local/bin/* && \
    apk add --no-cache git build-base && \
    apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing leveldb-dev && \
    pip install aiohttp pylru plyvel && \
    git clone -b $VERSION https://github.com/kyuupichan/electrumx.git && \
    cd electrumx && \
    python setup.py install && \
    apk del git build-base && \
    rm -rf /tmp/*

RUN addgroup -S electrumx && adduser -S -g electrumx electrumx  && \
    chown -R electrumx:electrumx /data

USER electrumx
ENV HOME /data
ENV DB_DIRECTORY /data
WORKDIR /data

EXPOSE 50001 50002

CMD ["/electrumx/electrumx_server.py"]
