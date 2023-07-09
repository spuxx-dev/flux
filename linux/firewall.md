# Firewall configuration

## Set up UFW firewall

```bash
sudo apt-get install ufw
sudo ufw allow 22/tcp
sudo ufw default allow outgoing
sudo ufw default deny incoming
```

## Ports

The following ports need to be open for the cluster to work properly:

```bash
# Microk8s' API server
sudo ufw allow 16443/tcp
```
