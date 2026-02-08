#!/bin/bash
/opt/mssql-tools18/bin/sqlcmd \
	-S localhost \
	-C \
	-U sa \
	-P m5SHlkY3MYiJ4OXFC64M#a \
	-d master \
	-l 30 \
	-t 30 \
	-i /bootstrap.sql

echo "Executed bootstrap.sql."
sleep 10
