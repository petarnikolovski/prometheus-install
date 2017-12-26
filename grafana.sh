#!/bin/bash

# Ubuntu 16.04

# chmod +x grafana.sh
# sudo pwd
# ./grafana.sh

wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.6.3_amd64.deb

sudo apt-get install -y adduser libfontconfig
sudo dpkg -i grafana_4.6.3_amd64.deb

sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

sudo rm grafana_4.6.3_amd64.deb
