#!/bin/bash

# Uninstall prometheus
sudo deluser prometheus

sudo rm -rf /etc/prometheus
sudo rm -rf /var/lib/prometheus

sudo rm /usr/local/bin/prometheus
sudo rm /usr/local/bin/promtool

sudo rm /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload
