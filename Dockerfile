FROM python:3.6-alpine3.6
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

COPY ./bin /usr/local/bin
COPY ./VERSION /tmp

RUN VERSION=$(cat /tmp/VERSION) && \
    chmod a+x /usr/local/bin/* && \
    apk add --no-cache git build-base openssl && \
    apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing leveldb-dev && \
    pip install aiohttp pylru plyvel && \
    git clone -b $VERSION https://github.com/kyuupichan/electrumx.git && \
    cd electrumx && \
    python setup.py install && \
    apk del git build-base && \
    rm -rf /tmp/*

RUN adduser -D -u 3002 electrumx && \ 
    mkdir /home/electrumx/data && \
    chown electrumx:electrumx /home/electrumx/data 

ENV TCP_PORT=50001
ENV SSL_PORT=50002
ENV DB_DIRECTORY /home/electrumx/data
ENV SSL_CERTFILE ${DB_DIRECTORY}/electrumx.crt
ENV SSL_KEYFILE ${DB_DIRECTORY}/electrumx.key
ENV HOST ""
USER electrumx

EXPOSE 50001 50002

CMD ["init"]
