#! /usr/bin/env bash
sudo apt install -y postgresql libpq-dev
sudo -u postgres psql -c "CREATE ROLE `whoami` WITH SUPERUSER LOGIN"

