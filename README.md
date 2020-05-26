# Prometheus Installation Script for Ubuntu 16.04 and 18.04 LTS

**Important:** This is a work in progress.

**Even more important:** If you actually plan to use this do not forget to edit configuration files to your needs (service files, YAML configuration files, etc.). Configuration files provided here are just generic files.

More about it here: [gist](https://gist.github.com/petarGitNik/18ae938aaef4c4ff58189df8a4fc7de9).

This script downloads the files in the current directory. You could change this.

### To Do

- [ ] Rewrite scripts so one could start it with `sudo ./full_installation` instead of doing `sudo` before script
- [ ] Write uninstallation scripts (both full uninstall and uninstallation of individual components)
- [ ] Add optional installation for `mysqld_exporter` and `postgresql_exporter`

Any suggestions and contributions are welcome.

### If you're new

I have written few Prometheus instructions that you may or may not find useful:

* [How to Write Rules for Prometheus](https://softwareadept.xyz/2018/01/how-to-write-rules-for-prometheus/)
* [How to Install Alertmanager on Ubuntu 16.04](https://softwareadept.xyz/2018/01/how-to-install-alertmanager-on-ubuntu-16.04/)
* [How to Install MySQL Exporter for Prometheus 2.0 on Ubuntu 16.04](https://softwareadept.xyz/2018/01/how-to-install-mysql-exporter-for-prometheus-2.0-on-ubuntu-16.04/)

If you find any mistake, or suggestion for enhancement that would be great.

# How to Use This?

Whether you are using this to install individual components or the full app, it is best to start scripts from the cloned repository. If you copy scripts anywhere else, the behaviour of the scripts is not guaranteed. **Note that these scripts will add Prometheus and other utilities to systemd as services, and enable the by default**.

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

Or run script as a `root` user.

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
