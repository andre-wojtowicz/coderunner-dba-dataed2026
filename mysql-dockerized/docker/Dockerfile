FROM mysql:8.0.45-wmi1 as builder

# That file does the DB initialization but also runs mysql daemon, by removing the last line it will only init
RUN ["sed", "-i", "s/exec \"$@\"/echo \"not running $@\"/", "/usr/local/bin/docker-entrypoint.sh"]

# needed for intialization
ENV MYSQL_ROOT_PASSWORD=jobe_runner

# jobe database
ENV MYSQL_DATABASE=jobe_runner
ENV MYSQL_USER=jobe_runner
ENV MYSQL_PASSWORD=jobe_runner

#COPY --chmod=644 bootstrap.sql /docker-entrypoint-initdb.d/
# --chmod disabled since BuildKit is not shipped on Debian 12
COPY bootstrap.sql /docker-entrypoint-initdb.d/
# equivalent of the --chmod parameter
RUN ["chmod", "644", "/docker-entrypoint-initdb.d/bootstrap.sql"]

# Need to change the datadir to something else that /var/lib/mysql because the parent docker file defines it as a volume.
# https://docs.docker.com/engine/reference/builder/#volume :
#       Changing the volume from within the Dockerfile: If any build steps change the data within the volume after
#       it has been declared, those changes will be discarded.
RUN ["/usr/local/bin/docker-entrypoint.sh", "mysqld", "--datadir", "/initialized-db"]

FROM mysql:8.0.45-wmi1

# remove MeCab because it's huge in /var
#RUN ["/usr/bin/apt", "purge", "-y", "mecab-ipadic", "mecab-ipadic-utf8"]

RUN mv /var /var_raw
COPY --from=builder /initialized-db /var_raw/lib/mysql_data

# --chmod disabled since BuildKit is not shipped on Debian 12
#COPY --chmod=755 jobe-entrypoint.sh /jobe-entrypoint.sh
COPY jobe-entrypoint.sh /jobe-entrypoint.sh
# equivalent of the --chmod parameter
RUN ["chmod", "755", "/jobe-entrypoint.sh"]

CMD /bin/bash -c /jobe-entrypoint.sh
