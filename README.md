# Flux

## Bootstrap

```bash
flux bootstrap github \
  --owner=spuxx1701 \
  --repository=flux \
  --branch=master \
  --read-write-key \
  --path=./clusters/jupiter \
  --components-extra=image-automation-controller,image-reflector-controller
```
