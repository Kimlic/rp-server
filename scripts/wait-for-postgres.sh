#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

until PGPASSWORD=kimlic psql -h db -U kimlic rp_core -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "cmd arg: ${cmd}"
>&2 echo "Postgres is up - entering app"
exec $cmd