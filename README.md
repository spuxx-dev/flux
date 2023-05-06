# Flux

## Bootstrap

Will bootstrap flux using github and the given repository. Requires a PAT with access to this repository.

```bash
flux bootstrap github \
  --owner=spuxx1701 \
  --repository=flux \
  --branch=master \
  --token-auth \
  --path=./cluster \
  --components-extra=image-automation-controller,image-reflector-controller
```
