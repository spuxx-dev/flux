# Home cluster

## Bootstrapping

The following guide assumes that the system is using an Ubuntu/Debian system and that `snap` is already installed.

### 1. Set up firewall

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
# Enable
sudo ufw enable
```

### 2. [Install microk8s](https://microk8s.io/docs/getting-started)

```bash
sudo snap install microk8s --classic --channel=1.30
```

Join the group to get the required permissions:

```bash

sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
chmod 0700 ~/.kube
su - $USER
```

Check status:

```bash
microk8s status --wait-ready
```

### 3. Enable required addons

```bash
microk8s enable dns
microk8s enable ingress
microk8s enable hostpath-storage
```

### 5. Install kubectl and k9s (optional)

Start by installing [homebrew](https://docs.brew.sh/Homebrew-on-Linux) since it's the easiest way to get kubectl and k9s.
