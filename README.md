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

Flux requires the GPG key for decrypting secrets. Put the key into a text file and add it to Kubernetes like so:
```bash
kubectl create secret generic sops-gpg --namespace=flux-system --from-file=/path/to/file
```
