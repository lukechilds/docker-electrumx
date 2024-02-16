
# docker-electrumx

[![Build Status](https://travis-ci.org/lukechilds/docker-electrumx.svg?branch=master)](https://travis-ci.org/lukechilds/docker-electrumx)
[![Docker Pulls](https://img.shields.io/docker/pulls/lukechilds/electrumx.svg)](https://hub.docker.com/r/lukechilds/electrumx/)
[![GitHub Donate](https://badgen.net/badge/GitHub/Sponsor/D959A7?icon=github)](https://github.com/sponsors/lukechilds)
[![Bitcoin Donate](https://badgen.net/badge/Bitcoin/Donate/F19537?icon=bitcoin)](https://lu.ke/tip/bitcoin)
[![Lightning Donate](https://badgen.net/badge/Lightning/Donate/F6BC41?icon=bitcoin-lightning)](https://lu.ke/tip/lightning)

> Run an Electrum server with one command

An easily configurable Docker image for running an Electrum server.

## Usage

```
docker run \
  -v /home/username/electrumx:/data \
  -e DAEMON_URL=http://user:pass@host:port \
  -e COIN=BitcoinSegwit \
  -p 50002:50002 \
  lukechilds/electrumx
```

If there's an SSL certificate/key (`electrumx.crt`/`electrumx.key`) in the `/data` volume it'll be used. If not, one will be generated for you.

You can view all ElectrumX environment variables here: https://github.com/spesmilo/electrumx/blob/master/docs/environment.rst

### TCP Port

By default only the SSL port is exposed. You can expose the unencrypted TCP port with `-p 50001:50001`, although this is strongly discouraged.

### WebSocket Port

You can expose the WebSocket port with `-p 50004:50004`.

### RPC Port

To access RPC from your host machine, you'll also need to expose port 8000. You probably only want this available to localhost: `-p 127.0.0.1:8000:8000`.

If you're only accessing RPC from within the container, there's no need to expose the RPC port.

### Version

You can also run a specific version of ElectrumX if you want.

```
docker run \
  -v /home/username/electrumx:/data \
  -e DAEMON_URL=http://user:pass@host:port \
  -e COIN=BitcoinSegwit \
  -p 50002:50002 \
  lukechilds/electrumx:v1.8.7
```

## Build

Define the spesmilo electrumx target branch

`Default branch: master`

```
export VERSION=master
```

Get the build
```
docker build . \
  -t lukechilds/electrumx:${VERSION}
  --build-args VERSION=${VERSION}
```

## License

MIT © Luke Childs
