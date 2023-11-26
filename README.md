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

## Setting up persistent storage

### Option 1: Hostpath storage

Microk8s offers an addon to easily implement persistent storage via a directory on the host sytem. The guide can be found [here](https://microk8s.io/docs/addon-hostpath-storage).

```bash
microk8s enable hostpath-storage
```

## Managing secrets

Guide: https://fluxcd.io/flux/guides/mozilla-sops/

Encrpyt a secret:

```bash
sops --age=age1xae7v2fsvs42znxu8zaz3cmgtktmqwmmrs5wp62w0pgvy5d9pf6q3qjg82 \
--encrypt --encrypted-regex '^(data|stringData)$' --in-place secret.yaml
```
