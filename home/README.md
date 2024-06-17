# Home cluster

## Bootstrapping

The following guide assumes that the system is using an Ubuntu/Debian system and that `snap` is already installed.

1. Set up firewall

```bash
sudo apt-get install ufw
# SSH
sudo ufw allow 22/tcp
# HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
# Microk8s' API server
sudo ufw allow 16443/tcp
# Allow all outgoing traffic
sudo ufw default allow outgoing
# Deny all other incoming traffic
sudo ufw default deny incoming
```

1. [Install microk8s](https://microk8s.io/docs/getting-started)

```bash
sudo snap install microk8s --classic --channel=1.30
```

