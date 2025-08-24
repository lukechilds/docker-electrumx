# Use Debian Trixie slim with Python 3.13
FROM python:3.13-slim-trixie

LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

ARG VERSION=1.18.0

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
      git \
      build-essential \
      python3-dev \
      libleveldb-dev \
      libssl-dev \
      openssl \
      ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy helper scripts (init, etc.)
COPY ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Clone ElectrumX source and install
RUN git clone --depth 1 --branch ${VERSION} https://github.com/spesmilo/electrumx.git /electrumx \
    && pip install --no-cache-dir uvloop plyvel \
    && pip install --no-cache-dir /electrumx \
    && rm -rf /electrumx

# ElectrumX config
VOLUME ["/data"]
ENV HOME=/data
ENV ALLOW_ROOT=1
ENV EVENT_LOOP_POLICY=uvloop
ENV DB_DIRECTORY=/data
ENV SERVICES=tcp://:50001,ssl://:50002,wss://:50004,rpc://0.0.0.0:8000
ENV SSL_CERTFILE=${DB_DIRECTORY}/electrumx.crt
ENV SSL_KEYFILE=${DB_DIRECTORY}/electrumx.key
ENV HOST=""

WORKDIR /data

# Ports: TCP, SSL, WS, RPC
EXPOSE 50001 50002 50004 8000

CMD ["init"]

