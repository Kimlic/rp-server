FROM bitwalker/alpine-elixir-phoenix:latest

MAINTAINER Pharos Production Inc. <dmytro@pharosproduction.com>

ENV LANG=C.UTF-8 \
    TERM=xterm \
    MIX_ENV=prod \
    DEBIAN_FRONTEND=noninteractive \
    APP_NAME=rp_server \
    VERSION=1.0.0 \
    REPLACE_OS_VARS=true \
    REFRESHED_AT=2018-07-30-4 \
    \
    RP_MOBILE_SECRET_KEY_BASE=TaRwP6iMHBxzDxN3A3nhQ649q86wLxR2tw4oKOTpJpIDdKNbmnDcg4WvQCcC79yY \
    RP_MOBILE_PORT=4000 \
    RP_MOBILE_HOST=localhost \
    RP_MOBILE_STATIC_SCHEME=https \
    RP_MOBILE_STATIC_HOST=localhost \
    RP_MOBILE_STATIC_PORT=443 \
    \
    RP_FRONT_SECRET_KEY_BASE=TaRwP6iMHBxzDxN3A3nhQ649q86wLxR2tw4oKOTpJpIDdKNbmnDcg4WvQCcC79yY \
    RP_FRONT_PORT=4001 \
    RP_FRONT_HOST=localhost \
    RP_FRONT_STATIC_SCHEME=https \
    RP_FRONT_STATIC_HOST=localhost \
    RP_FRONT_STATIC_PORT=443 \
    \
    RP_CORE_DB_DATABASE=rp_core \
    RP_CORE_DB_USERNAME=postgres \
    RP_CORE_DB_PASSWORD=postgres \
    RP_CORE_DB_HOSTNAME=db \
    RP_CORE_DB_PORT=5432 \
    RP_CORE_DB_POOL_SIZE=10

RUN apk --update add postgresql-client && rm -rf /var/cache/apk/*

RUN mkdir /$APP_NAME
WORKDIR /$APP_NAME
COPY . .

RUN MIX_ENV=$MIX_ENV mix do deps.get, deps.compile
RUN MIX_ENV=$MIX_ENV mix release --verbose --env=$MIX_ENV