#!/bin/bash

# Uninstall alertmanager
sudo deluser alertmanager

sudo rm -rf /etc/alertmanager
sudo rm -rf /var/lib/alertmanager/data

sudo rm /usr/local/bin/alertmanager
sudo rm /usr/local/bin/amtool

sudo rm /etc/systemd/system/alertmanager.service
sudo systemctl daemon-reload
