# Flux

This repository houses the cluster configuration for my Kubernetes cluster.

## Prerequisites

### Required packages

> 🛈 On older distros like Debian Buster, you might need to use the backport repos.
>
> ```bash
> sudo sh -c "echo 'deb http://archive.debian.org/debian buster-backports main contrib non-free' > /etc/> apt/sources.list.d/buster-backports.list"
> ```

The following packages need to be installed:

- `ufw` (Firewall)
- `snapd` (Required by microk8s)
- `open-iscsi` (Required by longhorn, see https://longhorn.io/docs/1.7.1/deploy/install/#installation-requirements)
- `wireguard` (Required by calico to encrypt node-to-node traffic)

```bash
sudo apt install \
  ufw \
  snapd \
  open-iscsi \
  wireguard
```

### Firewall configuration

```bash
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow 22/tcp # SSH
# Ports required by microk8s, see https://microk8s.io/docs/ports#services-binding-to-the-default-host-interface
sudo ufw allow 16443,10250,10250,10255,25000,12379,10257,10259,19001/tcp
sudo ufw allow 4789/udp
sudo ufw enable
```

### DNS configuration

Potentially, DNS needs to be configured and aligned to match DNS settings of other nodes.

```bash
sudo apt update
sudo apt install systemd-resolved
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
```

Afterwards, you might need to align DNS entries in `/etc/systemd/resolved.conf`.

## Setup microk8s

Install microk8s (see [documentation](https://microk8s.io/docs/getting-started)).

```bash
sudo snap install microk8s --classic --channel=1.31
```

Join the `microk8s` group to be able to run `kubectl` without `sudo`.

```bash
sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
chmod 0700 ~/.kube
# End session for the group change to take effect
su - $USER
```

Wait for microk8s to get ready and check the node.

```bash
microk8s status --wait-ready
microk8s kubectl get nodes
```

## Joining the cluster

Start by adding a DNS entry for the new node to **all existing nodes** `/etc/host` files.

```bash
sudo sh -c "echo '<ip> <hostname>' >> /etc/hosts"
```

Then run `microk8s add-node` on any existing node. The output will include a command you can then run
on the new node. For more information, see [here](https://microk8s.io/docs/clustering).

The node should now appear in your cluster. You can check with `kubectl get nodes`.

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
