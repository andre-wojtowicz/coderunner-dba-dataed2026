#!/bin/bash
# move cached data to the tmpfs
cp -rv /var_raw/* /var

chown mysql:mysql /var/lib/mysql
chmod 777 /var/lib/mysql

echo "jobe-entrypoint.sh"

/usr/local/bin/docker-entrypoint.sh mysqld --datadir=/var/lib/mysql_data --tmpdir=/var/lib/mysql --socket=/var/lib/mysql/mysql.sock --pid-file=/var/lib/mysql/mysql.pid --log-error=/var/lib/mysql/errors
