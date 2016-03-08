#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
  set -- mattermost "$@"
fi

if [ "$1" = 'mattermost' -a "$(id -u)" = '0' ]; then
  set -- gosu mattermost "$@"
fi

exec "$@"

