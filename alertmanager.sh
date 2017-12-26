#!/bin/bash

# Ubuntu 16.04

# Prometheus installation. It's a lousy script though.

# Example:
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

# alertmanager.yml

echo "global:
  smtp_smarthost: 'localhost:25'
  smtp_from: 'alertmanager@example.org'
  smtp_auth_username: 'alertmanager'
  smtp_auth_password: 'password'

templates:
- '/etc/alertmanager/template/*.tmpl'

route:
  repeat_interval: 3h
  receiver: team-X-mails

receivers:
- name: 'team-X-mails'
  email_configs:
  - to: 'team-X+alerts@example.org'" | sudo tee /etc/alertmanager/alertmanager.yml

# alertmanager.service

echo "[Unit]
Description=Prometheus Alert Manager service
Wants=network-online.target
After=network.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager \
    --config.file /etc/alertmanager/alertmanager.yml \
    --storage.path /var/lib/alertmanager/data
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/alertmanager.service

sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager

sudo rm alertmanager-0.12.0.linux-amd64.tar.gz
sudo rm -rf alertmanager-0.12.0.linux-amd64
