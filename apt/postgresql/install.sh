#! /usr/bin/env bash
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
sudo apt-get update
sudo apt-get install -y --no-install-recommends postgresql-13 libpq-dev
sudo service postgresql start
sudo -u postgres psql -c "CREATE ROLE `whoami` WITH SUPERUSER LOGIN"
