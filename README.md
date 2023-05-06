# Flux

## Bootstrap
Will bootstrap flux using github and the given repository. It'll ask for a PAT that will only be used during bootstrapping. After that, the deploy key created in the repository will be used.

```bash
flux bootstrap github \
  --owner=spuxx1701 \
  --repository=flux \
  --branch=master \
  --read-write-key \
  --path=./clusters/jupiter \
  --components-extra=image-automation-controller,image-reflector-controller
```
