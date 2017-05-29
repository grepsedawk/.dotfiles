#! /usr/bin/env bash
cd /tmp
wget http://www.scootersoftware.com/bcompare-4.2.2.22384_amd64.deb
sudo dpkg -i bcompare-4.2.2.22384_amd64.deb
sudo apt install -yf

