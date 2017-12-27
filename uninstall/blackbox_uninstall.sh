#!/bin/bash

# Uninstall balckbox exporter
sudo deluser blackbox_exporter

sudo rm -rf /etc/blackbox
sudo rm /usr/local/bin/blackbox_exporter

sudo rm /etc/systemd/system/blackbox_exporter.service
sudo systemctl daemon-reload
