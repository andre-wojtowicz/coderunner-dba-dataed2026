FROM mcr.microsoft.com/mssql/server:2019-CU30-ubuntu-20.04

# MSSQL configuration
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=m5SHlkY3MYiJ4OXFC64M#a
ENV MSSQL_PID=Express

# local configuration
ENV TZ=Europe/Warsaw

# hack for ZFS <0.8 and using tmpfs as storage
ENV LD_PRELOAD=/nodirect_open.so
COPY nodirect_open.so 		/nodirect_open.so

# bootstrap scripts
COPY entrypoint.sh          /entrypoint.sh
COPY bootstrap_harness.sh 	/bootstrap_harness.sh
COPY bootstrap.sh           /bootstrap.sh
COPY bootstrap.sql          /bootstrap.sql

# the correct way is to use the --chmod flag, but older docker versions
# do not support it
USER root
RUN chmod 644 /nodirect_open.so
RUN chmod 755 /entrypoint.sh
RUN chmod 755 /bootstrap_harness.sh
RUN chmod 755 /bootstrap.sh
RUN chmod 644 /bootstrap.sql

# generate bootstrap data as mssql user
#USER mssql
RUN /bin/bash -c /bootstrap_harness.sh

# prepare bootstrap data as root
#USER root
#RUN mv /mssql /mssql_raw
RUN mv /var /var_raw

#USER mssql
# this command will copy bootstrap data to the mounted tmpfs
# and run the server itself as the local mssql user
CMD /bin/bash -c /entrypoint.sh
