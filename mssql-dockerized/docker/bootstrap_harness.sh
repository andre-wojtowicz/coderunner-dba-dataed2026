#!/bin/bash
# start MSSQL and capture the PID for monitoring
su -c '/opt/mssql/bin/sqlservr' mssql & sqlpid=$!

# wait for the server to initialize
sleep 15

# execute initial T-SQL load
/bootstrap.sh

# wait for sqlserver to exit
while s=`ps -p $sqlpid -o s=` && [[ "$s" && "$s" != 'Z' ]]; do
    sleep 1
done

# create target directories
# this has to be done because the Dockerfile is using /var as a volume
#mkdir -p /mssql/data
#mkdir -p /mssql/log
#chown -R mssql:root /mssql

# change directory locations
#/opt/mssql/bin/mssql-conf set filelocation.defaultdatadir /mssql/data
#/opt/mssql/bin/mssql-conf set filelocation.defaultlogdir /mssql/log
#/opt/mssql/bin/mssql-conf set filelocation.masterdatafile /mssql/data/master.mdf
#/opt/mssql/bin/mssql-conf set filelocation.masterlogfile /mssql/data/mastlog.ldf

#cp -rp /var/opt/mssql/data /mssql/
#cp -rp /var/opt/mssql/log /mssql/
