# Host preparation (assuming Debian 12.13)

* act below as root user

   ```bash
   sudo su
   ```

* make sure Jobe server has `/etc/apache2/envvars` changed to accept UTF-8, i.e. `export LANG=C` is changed to `LANG=en_US.UTF-8`; in `/etc/locale.gen` uncomment `en_US.UTF-8 UTF-8` and regenerate locales:

   ```bash
   sed -i 's/^export LANG=C$/export LANG=en_US.UTF-8/' /etc/apache2/envvars
   sed -i 's/^# \(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
   locale-gen
   service apache2 restart
   ```

* install Debian packages

   ```bash
   apt install docker.io postgresql-client-15 libpq-dev python3-dev python3-venv -y
   ```

* allow Jobe users run Docker containers

  ```bash
  systemctl edit docker
  ```

  add the following

  ```plaintext
  [Service]
  ExecStartPost=/bin/chown root:jobe /var/run/docker.sock
  ```

  restart Docker

  ```bash
  systemctl daemon-reload
  systemctl restart docker
  ```

* install Python modules in virtual environment

  ```bash
  mkdir -p /opt/venv
  python3 -m venv /opt/venv/psql-dockerized
  source /opt/venv/psql-dockerized/bin/activate
  pip install -r requirements.txt
  deactivate
  ```

* if a firewall is configured with default block mode add a rule to allow connection via the Docker network

   ```bash
   ufw allow out to 172.21.0.0/16 port 5432
   ```

# Docker image preparation

* optional: in `docker` directory customize `Dockerfile` and `jobe-entrypoint.sh` in `tablespaces - start/end` comment sections

* build upstream image

   ```bash
   docker build -f docker/postgresql-upstream/Dockerfile -t postgres:14.22-wmi1 docker/postgresql-upstream/
   ```

* build Jobe image

   ```bash
   docker build -f docker/Dockerfile -t jobe-postgres:14.22-1 docker/
   ```

## Optional: starting container in interactive mode for debugging

```bash
docker run --read-only --publish 5432:5432 -ti --entrypoint "/bin/bash" --mount type=tmpfs,destination=/var,tmpfs-size=128M jobe-postgres:14.22-1

# while inside the container invoke the standard entrypoint
/jobe-entrypoint.sh
```

You can now connect to the PostgreSQL server on host:5432.

# Moodle

In the course question bank import the prototype and sample questions from `.xml` files.
