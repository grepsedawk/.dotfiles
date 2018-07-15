#! /usr/bin/env bash
sudo apt install -y postgresql libpq-dev
sudo service postgresql start
sudo -u postgres psql -c "CREATE ROLE `whoami` WITH SUPERUSER LOGIN"
