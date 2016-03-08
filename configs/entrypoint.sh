#!/bin/bash
set -e

: ${PG_HOST:=$DB_PORT_5432_TCP_ADDR}
: ${PG_USER:=${DB_ENV_POSTGRES_USER:='postgres'}}
: ${PG_PASS:=$DB_ENV_POSTGRES_PASSWORD}
: ${PG_DATA:=$DB_ENV_POSTGRES_DB}
export PG_HOST PG_USER PG_PASS PG_DATA

if [ "${1:0:1}" = '-' ]; then
  set -- mattermost "$@"
fi

if [ "$1" = 'mattermost' -a "$(id -u)" = '0' ]; then
  set -- gosu mattermost "$@"
fi

exec "$@"

