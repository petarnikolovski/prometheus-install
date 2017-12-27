#!/bin/bash

# Uninstall node exporter
sudo deluser node_exporter

sudo rm /usr/local/bin/node_exporter

sudo rm /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
