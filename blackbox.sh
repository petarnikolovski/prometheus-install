#!/bin/bash

# Ubuntu 16.04

# Prometheus installation. It's a lousy script though.

# Example:
# chmod +x blackbox.sh
# sudo pwd
# ./blackbox.sh

sudo adduser --no-create-home --disabled-login --shell /bin/false --gecos "Blackbox Exporter User" blackbox_exporter

sudo mkdir /etc/blackbox
sudo touch /etc/blackbox/blackbox.yml
sudo chown -R blackbox_exporter:blackbox_exporter /etc/blackbox
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.11.0/blackbox_exporter-0.11.0.linux-amd64.tar.gz
tar xvzf blackbox_exporter-0.11.0.linux-amd64.tar.gz
sudo cp blackbox_exporter-0.11.0.linux-amd64/blackbox_exporter /usr/local/bin/
sudo chown blackbox_exporter:blackbox_exporter /usr/local/bin/blackbox_exporter

# blackbox.yml

echo "modules:
  http_2xx_example:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2"]
      valid_status_codes: []  # Defaults to 2xx
      method: GET" | sudo tee /etc/blackbox/blackbox.yml

# blackbox_exporter.service

echo "[Unit]
Description=Prometheus blackbox exporter
After=network.target auditd.service

[Service]
User=blackbox_exporter
Group=blackbox_exporter
Type=simple
ExecStart=/usr/local/bin/blackbox_exporter --config.file=/etc/blackbox/blackbox.yml
Restart=on-failure

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/system/blackbox_exporter.service

sudo systemctl daemon-reload
sudo systemctl enable blackbox_exporter
sudo systemctl start blackbox_exporter

sudo rm blackbox_exporter-0.11.0.linux-amd64.tar.gz
sudo rm -rf blackbox_exporter-0.11.0.linux-amd64
