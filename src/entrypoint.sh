#!/bin/bash -l

set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- tlmgr "$@"
fi

exec "$@"
