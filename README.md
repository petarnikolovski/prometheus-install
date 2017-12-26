# Prometheus 2.0.0 Installation Script for Ubuntu 16.04 LTS

**Important:** This is a work in progress. Do not use this.

More about it here: [gist](https://gist.github.com/petarGitNik/18ae938aaef4c4ff58189df8a4fc7de9).

This script downloads the files in the current directory. You could change this.

# How to Use This?

Whether you are using this to install individual components or the full app, it is best to start scripts from the cloned repository. If you copy scripts anywhere else, the behaviour of the scripts is not guaranteed. Note that these scripts will add prometheus and other utilities to systemd as services, and enable the by default.

## Full Installation

Full installation will install the following:

* Prometheus
* Alertmanager
* Node Exporter
* Blackbox Exporter
* Grafana

Scripts have many `sudo`s, so before you start the full installation, do:

```bash
sudo pwd
```

just to make sure, `sudo` in scripts won't interrupt you. After that you can run script as:

```bash
./full_installation.sh
```

## Installation of Individual Components

Same rules apply as for the full installation before you try to execute other scripts:

```bash
sudo pwd
```

just to make sure, `sudo` in scripts won't interrupt you. And to install individual components, use:

* Prometheus: `./prometheus.sh`
* Alertmanager: `./alertmanager.sh`
* Node Exporter: `./node.sh`
* Blackbox Exporter: `./blackbox.sh`
* Grafana: `./grafana.sh`
