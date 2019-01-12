FROM elixir:1.7.4-alpine as builder

LABEL company="Kimlic"
LABEL version="1.0.0"

ENV LANG C.UTF-8 \
  REFRESHED_AT 2019-01-12-1 \
  TERM xterm \
  DEBIAN_FRONTEND noninteractive
ENV ELIXIR_VERSION v1.7.4

RUN apk add --update \
  git \
  build-base \
  wget \
  bash

WORKDIR /opt/$rp-server_build/
COPY . /opt/$rp-server_build/
# RUN wget -O - https://github.com/kimlic/rp-server/tarball/master | tar xz \
#   && mv Kimlic-rp-server-* rp-server \
#   && cd rp-server

RUN mix local.hex --force && mix local.rebar --force
RUN MIX_ENV=prod mix do deps.get --only prod, deps.compile --force
RUN MIX_ENV=prod mix release --env=prod

RUN mkdir /opt/rp-server \
  && tar xvzf ./_build/prod/rel/rp-server/releases/1.0.0/rp-server.tar.gz -C /opt/rp-server
WORKDIR /opt/rp-server
RUN rm -rf /opt/rp-server_build
COPY ./rel/config/hosts.config ./etc/hosts.config
COPY ./rel/config/.hosts.erlang ./.hosts.erlang

CMD ["/bin/bash"]

#############################################################

FROM alpine:3.8

LABEL company="Pharos Production Inc."
LABEL version="1.0.0"

ENV REPLACE_OS_VARS=true \
  HOSTNAME=${HOSTNAME}

RUN apk add --update \
  bash \
  openssl

ENV LANG C.UTF-8 \
  REFRESHED_AT 2019-01-04-1 \
  TERM xterm \
  DEBIAN_FRONTEND noninteractive

COPY --from=builder /opt/rp-server /usr/local/bin/rp-server
WORKDIR /usr/local/bin/rp-server

CMD ["/bin/bash"]