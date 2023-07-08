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
# SSH

# Microk8s' API server
sudo ufw allow 16443/tcp

# In case you want to use mailu, also expose the following ports:
sudo ufw allow 25/tcp # SMTP
sudo ufw allow 465/tcp # SMTPS
sudo ufw allow 993/tcp # IMAPS
sudo ufw allow 995/tcp # POP3S
```
