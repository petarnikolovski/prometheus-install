#!/bin/bash

# Ubuntu 16.04

# Prometheus installation. It's a lousy script though.

# Example:
# chmod +x full_installation.sh
# sudo pwd
# ./full_installation.sh

./prometheus.sh
./node.sh
./blackbox.sh
./alertmanager.sh
