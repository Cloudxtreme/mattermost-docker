#!/bin/bash
set -e

: ${PG_HOST:=$DB_PORT_5432_TCP_ADDR}
: ${PG_USER:=${DB_ENV_POSTGRES_USER:='postgres'}}
: ${PG_PASS:=$DB_ENV_POSTGRES_PASSWORD}
: ${PG_DATA:=$DB_ENV_POSTGRES_DB}
export PG_HOST PG_USER PG_PASS PG_DATA

sed -i 's/PG_HOST/${PG_HOST}/g' /mattermost_data/config/config.json
sed -i 's/PG_USER/${PG_USER}/g' /mattermost_data/config/config.json
sed -i 's/PG_PASS/${PG_PASS}/g' /mattermost_data/config/config.json
sed -i 's/PG_DATA/${PG_DATA}/g' /mattermost_data/config/config.json
sed -i '4,15d' /entrypoint.sh

if [ "${1:0:1}" = '-' ]; then
  set -- mattermost "$@"
fi

if [ "$1" = 'mattermost' -a "$(id -u)" = '0' ]; then
  set -- gosu mattermost "$@"
fi

exec "$@"

