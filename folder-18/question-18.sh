#!/bin/bash

export location=/home/student/CKA-material
export question=question-18
export folder=folder-18
export LOGFILE=$question.log
touch $LOGFILE >> $LOGFILE 2>&1

./tools/cleanup.sh  >> $LOGFILE 2>&1

cat <<EOF | kind create cluster --image kindest/node:v1.29.0@sha256:eaa1450915475849a73a9227b8f201df25e55e268e5d619312131292e324d570  --config - > /dev/null 2>&1
kind: Cluster
name: $question
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  podSubnet: "10.199.0.0/16"
  serviceSubnet: "10.200.0.0/16"
nodes:
- role: control-plane
- role: worker
- role: worker
EOF


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-18/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
 


# List all namespaces
namespaces=$(kubectl get namespaces -o=jsonpath='{.items[*].metadata.name}')

# Iterate over each namespace and create a context
for namespace in $namespaces; do
  kubectl config set-context "$namespace" --cluster "$question" --user kind-$question  --namespace="$namespace" > /dev/null 2>&1
done
