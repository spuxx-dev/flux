# Delete CRD finalizers, instances and definitions
# See: https://longhorn.io/docs/1.7.1/deploy/uninstall/#problems-with-crds
for crd in $(kubectl get crd -o jsonpath={.items[*].metadata.name} | tr ' ' '\n' | grep longhorn.io); do
  kubectl -n longhorn-system get $crd -o yaml | sed "s/\- longhorn.io//g" | kubectl apply -f -
  kubectl -n longhorn-system delete $crd --all
  kubectl delete crd/$crd
done
