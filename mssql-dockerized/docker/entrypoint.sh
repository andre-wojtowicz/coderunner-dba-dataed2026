#!/bin/bash
# move cached data to the tmpfs
#chown mssql:root /mssql
#cp -rp /mssql_raw/* /mssql/
cp -rp /var_raw/* /var/
chown mssql:root /var/opt/mssql

# start MSSQL and capture the PID for monitoring
/opt/mssql/bin/sqlservr & sqlpid=$!

# wait for sqlserver to exit
while s=`ps -p $sqlpid -o s=` && [[ "$s" && "$s" != 'Z' ]]; do
    sleep 1
done
