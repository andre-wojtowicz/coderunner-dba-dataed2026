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
   apt install docker.io python3-dev python3-venv -y
   ```

* install MSSQL client tools

   ```bash
   curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

   echo "deb [arch=amd64] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/mssql-tools.list

   apt update
   apt install mssql-tools
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
  python3 -m venv /opt/venv/mssql-dockerized
  source /opt/venv/mssql-dockerized/bin/activate
  pip install -r requirements.txt
  deactivate
  ```

* if a firewall is configured with default block mode add a rule to allow connection via the Docker network

   ```bash
   ufw allow out to 172.16.0.0/12 port 1433
   ```

# Docker image preparation

* `O_DIRECT` hack library

  In order to run MSSQL Docker container on ZFS or with `/var` in a RAM disk (like in this repository), a suitable library needs to be built that strips the `O_DIRECT` flag from IO requests.

  For the best compatibility make sure that the `Dockerfile` in this repository is using the same base image as the main MSSQL `Dockerfile`.

  In order to create the library:
 
  * if needed, update the `docker/o_direct_hack/nodirect_open.c` file from the [source repository](https://github.com/t-oster/mssql-docker-zfs)
  * build this container: `docker build -t mssql-2019-nodirect_open docker/o_direct_hack/`
  * instantiate the container: `docker create -ti --name dummy mssql-2019-nodirect_open:latest bash`
  * copy the compiler library out: `docker cp dummy:/nodirect_open.so docker/`
  * clean up: `docker rm dummy && docker rmi mssql-2019-nodirect_open`

* build Jobe image

   ```bash
   docker build -f docker/Dockerfile -t jobe-mssql:2019-CU30 docker/
   ```

## Optional: starting container in interactive mode for debugging

```bash
docker run --read-only --publish 1433:1433 -ti --entrypoint "/bin/bash" --mount type=tmpfs,destination=/var,tmpfs-size=128M jobe-mssql:2019-CU30

# while inside the container invoke the standard entrypoint
./entrypoint.sh
```

You can now connect to the SQL Server on host:1433.

# Moodle

In the course question bank import the prototype and sample questions from `.xml` files.