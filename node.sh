#!/bin/bash

# Ubuntu 16.04

# Prometheus installation. It's a lousy script though.

# Example:
# chmod +x node.sh
# sudo pwd
# ./node.sh

sudo adduser --no-create-home --disabled-login --shell /bin/false --gecos "Node Exporter User" node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v0.15.2/node_exporter-0.15.2.linux-amd64.tar.gz
tar xvzf node_exporter-0.15.2.linux-amd64.tar.gz
sudo cp node_exporter-0.15.2.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# node_exporter.service

echo "[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

sudo rm node_exporter-0.15.2.linux-amd64.tar.gz
sudo rm -rf node_exporter-0.15.2.linux-amd64
