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

* install MySQL APT repository and client tools

   ```bash
   wget https://dev.mysql.com/get/mysql-apt-config_0.8.36-1_all.deb
   apt install ./mysql-apt-config_0.8.36-1_all.deb -y # configure 'MySQL Server & Cluster' to 'mysql-8.0'
   rm mysql-apt-config_0.8.36-1_all.deb
   apt update
   apt install mysql-community-client
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
  python3 -m venv /opt/venv/mysql-dockerized
  source /opt/venv/mysql-dockerized/bin/activate
  pip install -r requirements.txt
  deactivate
  ```

* if a firewall is configured with default block mode add a rule to allow connection via the Docker network

   ```bash
   ufw allow out to 172.16.0.0/12 port 3306
   ```

# Docker image preparation

* build upstream image

   ```bash
   docker build -f docker/mysql-upstream/Dockerfile -t mysql:8.0.45-wmi1 docker/mysql-upstream/
   ```

* build Jobe image

   ```bash
   docker build -f docker/Dockerfile -t jobe-mysql:8.0.45-1 docker/
   ```

## Optional: starting container in interactive mode for debugging

```bash
docker run --publish 3306:3306 -ti --entrypoint "/bin/bash" --mount type=tmpfs,destination=/var,tmpfs-size=512M jobe-mysql:8.0.45-1

# while inside the container invoke the standard entrypoint
/jobe-entrypoint.sh
```

You can now connect to the MySQL server on host:3306.

# Moodle

In the course question bank import the prototype and sample questions from `.xml` files.