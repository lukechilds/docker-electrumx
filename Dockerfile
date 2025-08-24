ARG VERSION=1.18.0

FROM debian:trixie-slim
LABEL maintainer="Luke Childs <lukechilds123@gmail.com>"

ARG VERSION

COPY ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

RUN apt-get --yes update
RUN apt-get --yes install python3-pip build-essential libc6-dev libncurses5-dev libncursesw5-dev libleveldb-dev git
RUN pip3 install --break-system-packages plyvel uvloop

RUN git clone -b $VERSION https://github.com/spesmilo/electrumx.git
RUN cd electrumx &&  python3 -m pip install --break-system-packages .

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

EXPOSE 50001 50002 50004 8000

CMD ["init"]
