FROM python:3.10-alpine3.18

# Set environment variable for ElectrumX version
ENV VERSION=HEAD

# Install build dependencies and libraries
RUN apk add --no-cache \
    git \
    build-base \
    openssl \
    leveldb-dev \
    rocksdb-dev \
    libffi-dev \
    libressl-dev \
    sqlite-dev

# Install required Python packages
RUN pip install --no-cache-dir \
    aiohttp \
    pylru \
    plyvel \
    websockets \
    uvloop \
    python-rocksdb

# Clone and install ElectrumX
RUN git clone -b $VERSION https://github.com/spesmilo/electrumx.git /electrumx \
    && cd /electrumx \
    && python3 setup.py install

# Clean up build dependencies (optional, for smaller image)
RUN apk del git build-base

# Set working directory
WORKDIR /electrumx

# Expose default ElectrumX TCP and SSL ports
EXPOSE 50001 50002

# Run ElectrumX server
CMD ["python3", "-m", "electrumx.server.controller"]
