# Flux

This repository houses the cluster configuration for my Kubernetes cluster.

## Prerequisites

### Required packages

The following packages need to be installed:

- `ufw` (Firewall)
- `snapd` (Required by microk8s)
- `open-iscsi` (Required by longhorn, see https://longhorn.io/docs/1.7.1/deploy/install/#installation-requirements)

```bash
sudo apt install \
  ufw \
  snapd \
  open-iscsi
```

### Firewall configuration

```bash
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow 22/tcp # SSH
sudo ufw allow 16443/tcp # Microk8s' API server
sudo ufw enable
```

## Setup microk8s

## Bootstrap Flux

The repository is maintained with Flux. In case of a new fresh install of the cluster, Flux needs to be bootstrapped.

```bash
flux bootstrap github \
  --owner=spuxx1701 \
  --repository=flux \
  --branch=main \
  --token-auth \
  --path=./clusters/constellation \
  --components-extra=image-automation-controller,image-reflector-controller
```

When prompted, enter the PAT that Flux can use to access this repository.

For everything to work, secret decryption must also be enabled. Download the age keyfile and then do:

```bash
cat age.agekey |
kubectl create secret generic sops-age \
--namespace=flux-system \
--from-file=age.agekey=/dev/stdin
```

## Setting up observability

You can enable the observability stack (grafana, prometheus, loki etc.) via:

```bash
microk8s enable observability
```

## Other Tweaks

To reduce the disk space occupied by Kubernetes, it can be useful to make its garbage collection more aggressive (see [here](https://stackoverflow.com/a/77270875)):

```bash
# /var/snap/microk8s/current/args/kubelet
--image-gc-high-threshold=50
--image-gc-low-threshold=40
--maximum-dead-containers=0
```
