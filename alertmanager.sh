#!/bin/bash

# Make alertmanager user
sudo adduser --no-create-home --disabled-login --shell /bin/false --gecos "Alertmanager User" alertmanager

# Make directories and dummy files necessary for alertmanager
sudo mkdir /etc/alertmanager
sudo mkdir /etc/alertmanager/template
sudo mkdir -p /var/lib/alertmanager/data
sudo touch /etc/alertmanager/alertmanager.yml


sudo chown -R alertmanager:alertmanager /etc/alertmanager
sudo chown -R alertmanager:alertmanager /var/lib/alertmanager

# Download alertmanager and copy utilities to where they should be in the filesystem
wget https://github.com/prometheus/alertmanager/releases/download/v0.12.0/alertmanager-0.12.0.linux-amd64.tar.gz
tar xvzf alertmanager-0.12.0.linux-amd64.tar.gz

sudo cp alertmanager-0.12.0.linux-amd64/alertmanager /usr/local/bin/
sudo cp alertmanager-0.12.0.linux-amd64/amtool /usr/local/bin/
sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown alertmanager:alertmanager /usr/local/bin/amtool

# Populate configuration files
cat ./alertmanager/alertmanager.yml | sudo tee /etc/alertmanager/alertmanager.yml
cat ./alertmanager/alertmanager.service | sudo tee /etc/systemd/system/alertmanager.service

# systemd
sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager

# Installation cleanup
sudo rm alertmanager-0.12.0.linux-amd64.tar.gz
sudo rm -rf alertmanager-0.12.0.linux-amd64
