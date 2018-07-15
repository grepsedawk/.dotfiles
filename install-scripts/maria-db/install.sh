#! /usr/bin/env bash
sudo apt update -y
sudo apt install -y mariadb-server libmariadb-dev
if ! grep -q "export MYSQL_PASSWORD" $HOME/.env; then
  MYSQL_USERNAME=`whoami`
  MYSQL_PASSWORD=`openssl rand -base64 32`
  echo "export MYSQL_USER='${MYSQL_USERNAME}'" >> $HOME/.env
  echo "export MYSQL_PASSWORD='${MYSQL_PASSWORD}'" >> $HOME/.env
  cat << EOF > $HOME/.my.cnf
[mysql]
password=${MYSQL_PASSWORD}
EOF
  sudo service mysql start
  sudo mysql -e "CREATE USER '${MYSQL_USERNAME}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}'"
  sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USERNAME}'@'localhost';"
fi
