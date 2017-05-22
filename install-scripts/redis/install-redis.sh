#! /usr/bin/env bash
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable
make
sudo make install
sudo mkdir /etc/redis
sed -i 's/^supervised.*/supervised systemd/' /tmp/redis-stable/redis.conf
sed -i 's/^dir.*/dir \/var\/lib\/redis/' /tmp/redis-stable/redis.conf
sudo cp /tmp/redis-stable/redis.conf /etc/redis
sudo cp $HOME/.dotfiles/install-scripts/redis/redis.service /etc/systemd/system/redis.service
sudo adduser --system --group --no-create-home redis
sudo mkdir /var/lib/redis
sudo chown redis:redis /var/lib/redis
sudo chmod 770 /var/lib/redis
sudo systemctl start redis
sudo systemctl enable redis

