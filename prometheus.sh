#!/bin/bash

# Ubuntu 16.04

# Prometheus installation. It's a lousy script though.

# Example:
# chmod +x prometheus.sh
# sudo pwd
# ./prometheus.sh

sudo adduser --no-create-home --disabled-login --shell /bin/false --gecos "Prometheus Monitoring User" prometheus
sudo adduser --no-create-home --disabled-login --shell /bin/false --gecos "Node Exporter User" node_exporter
sudo adduser --no-create-home --disabled-login --shell /bin/false --gecos "Alertmanager User" alertmanager
sudo adduser --no-create-home --disabled-login --shell /bin/false --gecos "Blackbox Exporter User" blackbox_exporter

sudo mkdir /etc/prometheus
sudo mkdir /etc/alertmanager
sudo mkdir /etc/alertmanager/template
sudo mkdir /etc/blackbox
sudo mkdir /var/lib/prometheus
sudo mkdir -p /var/lib/alertmanager/data

sudo touch /etc/prometheus/prometheus.yml
sudo touch /etc/alertmanager/alertmanager.yml
sudo touch /etc/blackbox/blackbox.yml

sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R alertmanager:alertmanager /etc/alertmanager
sudo chown -R blackbox_exporter:blackbox_exporter /etc/blackbox
sudo chown prometheus:prometheus /var/lib/prometheus
sudo chown -R alertmanager:alertmanager /var/lib/alertmanager

wget https://github.com/prometheus/prometheus/releases/download/v2.0.0/prometheus-2.0.0.linux-amd64.tar.gz
wget https://github.com/prometheus/alertmanager/releases/download/v0.12.0/alertmanager-0.12.0.linux-amd64.tar.gz
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.11.0/blackbox_exporter-0.11.0.linux-amd64.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v0.15.2/node_exporter-0.15.2.linux-amd64.tar.gz
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.6.3_amd64.deb

tar xvzf prometheus-2.0.0.linux-amd64.tar.gz
tar xvzf alertmanager-0.12.0.linux-amd64.tar.gz
tar xvzf blackbox_exporter-0.11.0.linux-amd64.tar.gz
tar xvzf node_exporter-0.15.2.linux-amd64.tar.gz

sudo cp prometheus-2.0.0.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.0.0.linux-amd64/promtool /usr/local/bin/
sudo cp -r prometheus-2.0.0.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.0.0.linux-amd64/console_libraries /etc/prometheus
sudo cp alertmanager-0.12.0.linux-amd64/alertmanager /usr/local/bin/
sudo cp alertmanager-0.12.0.linux-amd64/amtool /usr/local/bin/
sudo cp blackbox_exporter-0.11.0.linux-amd64/blackbox_exporter /usr/local/bin/
sudo cp node_exporter-0.15.2.linux-amd64/node_exporter /usr/local/bin/

sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown alertmanager:alertmanager /usr/local/bin/amtool
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo chown blackbox_exporter:blackbox_exporter /usr/local/bin/blackbox_exporter

# prometheus.yml

echo "global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']" | sudo tee /etc/prometheus/prometheus.yml

# blackbox.yml

echo "modules:
  http_2xx_example:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2"]
      valid_status_codes: []  # Defaults to 2xx
      method: GET" | sudo tee /etc/blackbox/blackbox.yml

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

# prometheus.service

echo "[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/prometheus.service

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

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

# grafana installation

sudo apt-get install -y adduser libfontconfig
sudo dpkg -i grafana_4.6.3_amd64.deb

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server
sudo /bin/systemctl start grafana-server

# cleanup

sudo rm prometheus-2.0.0.linux-amd64.tar.gz
sudo rm alertmanager-0.12.0.linux-amd64.tar.gz
sudo rm blackbox_exporter-0.11.0.linux-amd64.tar.gz
sudo rm node_exporter-0.15.2.linux-amd64.tar.gz
sudo rm grafana_4.6.3_amd64.deb

sudo rm -rf prometheus-2.0.0.linux-amd64
sudo rm -rf alertmanager-0.12.0.linux-amd64
sudo rm -rf blackbox_exporter-0.11.0.linux-amd64
sudo rm -rf node_exporter-0.15.2.linux-amd64
