# Home cluster

## Bootstrapping

The following guide assumes that the system is using an Ubuntu/Debian system and that `snap` is already installed.

**Requirements:**

* [homebrew](https://docs.brew.sh/Homebrew-on-Linux)
* Build essentials: `sudo apt install build-essential`

### 1. Set up firewall

```bash
sudo apt-get install ufw
# SSH
sudo ufw allow 22/tcp
# HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
# DNSMASQ
sudo ufw allow 53
# Microk8s' API server
sudo ufw allow 16443/tcp
# Allow all outgoing traffic
sudo ufw default allow outgoing
# Deny all other incoming traffic
sudo ufw default deny incoming
# Enable
sudo ufw enable
```

### 2. Set up local DNS server

Install dnsmasq:

```bash
sudo apt-get install dnsmasq
```

Configure `/etc/dnsmasq.conf`:

```bash
# /etc/dnsmasq.conf
address=/assistant.home/192.168.178.77
# ...
# Add upstream DNS servers to handle external domains
server=1.1.1.1
server=1.0.0.1
```

If required, configure `systemd-resolved` to not stub DNS. This can be checked by checking if `systemd-resolved` listens to port 53: `lsof -i :53`

```bash
# /etc/systemd/resolved.conf
DNSStubListener=no
```

Restart dnsmasq:

```bash
sudo systemctl restart dnsmasq
```

Don't forget to configure the DNS server in your router.

### 3. [Install microk8s](https://microk8s.io/docs/getting-started)

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

Get the config and copy it to `./kube/config`:

```bash
microk8s config
```

### 4. Enable required addons

```bash
microk8s enable dns
microk8s enable ingress
microk8s enable hostpath-storage
```

### 5. Install Flux

FluxCD is deployed via the [bootstrap](https://fluxcd.io/flux/cmd/flux_bootstrap/) command:

```bash
flux bootstrap github \
  --owner=spuxx1701 \
  --repository=flux \
  --branch=master \
  --token-auth \
  --path=./home
```

### 6. Set up required users

```bash
sudo useradd -u 9001 -m -d /home/homeassistant homeassistant
```

### 7. Install other tools (optional)

* `brew install k9s`
