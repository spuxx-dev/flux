# Flux

This repository houses the cluster configuration for my Kubernetes cluster.

## Bootstrap Flux

The repository is maintained with Flux. In case of a new fresh install of the cluster, Flux needs to be bootstrapped.

```bash
flux bootstrap github \
  --owner=spuxx1701 \
  --repository=flux \
  --branch=master \
  --token-auth \
  --path=./cluster \
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

## Setting up persistent storage

### Option 1: Hostpath storage

Microk8s offers an addon to easily implement persistent storage via a directory on the host sytem. The guide can be found [here](https://microk8s.io/docs/addon-hostpath-storage).

```bash
microk8s enable hostpath-storage
```

We usually use UID `9999` for container runtimes that do not require access to storage on the host. For containers that do, we create new users that have their own home folders. The following users are reserved by existing applications:

```bash
9001 - mariadb
9002 - monitoring
9003 - audiobookshelf
9004 - actualbudget
```
