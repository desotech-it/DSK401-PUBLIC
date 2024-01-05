#!/bin/bash

export location=/home/student/CKA-material
export question=question-37
export folder=folder-37
export LOGFILE=$question.log
touch $LOGFILE >> $LOGFILE 2>&1

./tools/cleanup.sh  >> $LOGFILE 2>&1

cat <<EOF | kind create cluster --config - > /dev/null 2>&1
kind: Cluster
name: $question
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  podSubnet: "10.199.0.0/16"
  serviceSubnet: "10.200.0.0/16"
nodes:
- role: control-plane
  image: kindest/node:v1.29.0@sha256:eaa1450915475849a73a9227b8f201df25e55e268e5d619312131292e324d570
- role: worker
  image: kindest/node:v1.29.0@sha256:eaa1450915475849a73a9227b8f201df25e55e268e5d619312131292e324d570
- role: worker
  image: kindest/node:v1.28.0@sha256:b7a4cad12c197af3ba43202d3efe03246b3f0793f162afb40a33c923952d5b31
EOF

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-37/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1

kubectl drain question-37-worker2 --ignore-daemonsets --delete-emptydir-data > $LOGFILE 2>&1

kubectl delete node question-37-worker2 > $LOGFILE 2>&1

alias ssh='function _run () { docker exec -it "$1" /bin/bash; }; _run' >> $LOGFILE 2>&1