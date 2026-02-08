FROM postgres:14.22-wmi1 as builder

# That file does the DB initialization but also runs the server, by removing the last line it will only init
RUN ["sed", "-i", "s/exec \"$@\"/echo \"not running $@\"/", "/usr/local/bin/docker-entrypoint.sh"]

# needed for intialization
ENV POSTGRES_USER=root
ENV POSTGRES_PASSWORD=jobe_runner

# jobe database
ENV POSTGRES_DB=jobe_runner

COPY bootstrap.sql /docker-entrypoint-initdb.d/bootstrap.sql

# the correct way is to use the --chmod flag, but older docker versions
# do not support it
RUN chmod 644 /docker-entrypoint-initdb.d/bootstrap.sql

# Need to change the datadir to something else that /var/lib/mysql because the parent docker file defines it as a volume.
# https://docs.docker.com/engine/reference/builder/#volume :
#       Changing the volume from within the Dockerfile: If any build steps change the data within the volume after
#       it has been declared, those changes will be discarded.
ENV PGDATA=/initialized-db
RUN ["/usr/local/bin/docker-entrypoint.sh", "postgres"]

FROM postgres:14.22-wmi1

# we need a private /run directory since we'll be only mounting /var as read-write
RUN unlink /var/run && mkdir /var/run && chmod 755 /var/run && cp -r /run/* /var/run

RUN mv /var /var_raw
COPY --from=builder /initialized-db /var_raw/lib/psql_data

RUN mkdir -p /var_raw/abd/tablespace1
RUN mkdir -p /var_raw/abd/tablespace2

COPY jobe-entrypoint.sh /jobe-entrypoint.sh

RUN chmod 755 /jobe-entrypoint.sh

CMD /bin/bash -c /jobe-entrypoint.sh
