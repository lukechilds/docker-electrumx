ARG VERSION=master

FROM python:3.9.16-slim-bullseye
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

ARG VERSION

COPY ./bin /usr/local/bin

RUN chmod a+x /usr/local/bin/* && \
    apt-get update &&\
    apt-get install -y --no-install-suggests --no-install-recommends\
    gcc \
    g++ \
    git \
    libbz2-dev \
    liblz4-dev \
    zlib1g-dev \
    libsnappy-dev \
    libleveldb-dev \
    librocksdb-dev \
    && pip install uvloop \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/spesmilo/electrumx.git \
    && cd electrumx \
    && git checkout ${VERSION} \
    && pip install -r requirements.txt \
    && python setup.py install \
    && apt purge -y \
    gcc \
    g++ \
    git \
    libbz2-dev \
    liblz4-dev \
    zlib1g-dev \
    libsnappy-dev \
    libleveldb-dev \
    librocksdb-dev \
    && rm -rf /tmp/*

VOLUME ["/data"]
ENV HOME /data
ENV ALLOW_ROOT 1
ENV EVENT_LOOP_POLICY uvloop
ENV DB_DIRECTORY /data
ENV SERVICES=tcp://:50001,ssl://:50002,wss://:50004,rpc://0.0.0.0:8000
ENV SSL_CERTFILE ${DB_DIRECTORY}/electrumx.crt
ENV SSL_KEYFILE ${DB_DIRECTORY}/electrumx.key
ENV HOST ""

USER 65534

WORKDIR /data

EXPOSE 50001 50002 50004 8000

CMD ["init"]
