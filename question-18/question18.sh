#!/bin/bash

# List all namespaces
namespaces=$(kubectl get namespaces -o=jsonpath='{.items[*].metadata.name}')

# Iterate over each namespace and create a context
for namespace in $namespaces; do
  kubectl config set-context "$namespace" --cluster=desocluster --user=kubernetes-admin --namespace="$namespace" > /dev/null 2>&1
done
