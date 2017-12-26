#!/bin/bash

# Ubuntu 16.04

# chmod +x alertmanager.sh
# sudo pwd
# ./alertmanager.sh

sudo adduser --no-create-home --disabled-login --shell /bin/false --gecos "Alertmanager User" alertmanager
sudo mkdir /etc/alertmanager
sudo mkdir /etc/alertmanager/template
sudo mkdir -p /var/lib/alertmanager/data
sudo touch /etc/alertmanager/alertmanager.yml
sudo chown -R alertmanager:alertmanager /etc/alertmanager
sudo chown -R alertmanager:alertmanager /var/lib/alertmanager
wget https://github.com/prometheus/alertmanager/releases/download/v0.12.0/alertmanager-0.12.0.linux-amd64.tar.gz
tar xvzf alertmanager-0.12.0.linux-amd64.tar.gz
sudo cp alertmanager-0.12.0.linux-amd64/alertmanager /usr/local/bin/
sudo cp alertmanager-0.12.0.linux-amd64/amtool /usr/local/bin/
sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown alertmanager:alertmanager /usr/local/bin/amtool

cat ./alertmanager/alertmanager.yml | sudo tee /etc/alertmanager/alertmanager.yml
cat ./alertmanager/alertmanager.service | sudo tee /etc/systemd/system/alertmanager.service

sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager

sudo rm alertmanager-0.12.0.linux-amd64.tar.gz
sudo rm -rf alertmanager-0.12.0.linux-amd64
