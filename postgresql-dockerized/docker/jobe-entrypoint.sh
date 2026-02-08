#!/bin/bash
# move cached data to the tmpfs
cp -rvp /var_raw/* /var

#chown postgres:postgres /var/lib/postgres
#chmod 777 /var/lib/postgres
chown -R postgres: /var/abd

echo "jobe-entrypoint.sh"

PGDATA=/var/lib/psql_data /usr/local/bin/docker-entrypoint.sh postgres
