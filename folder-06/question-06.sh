#!/bin/bash

export location=/home/student/CKA-material
export question=question-06
export folder=folder-06
export LOGFILE=$question.log
touch $LOGFILE >> $LOGFILE 2>&1

./cleanup.sh >> $LOGFILE 2>&1

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


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-06/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
kubectl create ns sandwich  >> $LOGFILE 2>&1


manifest_content=$(cat <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: question06
--- 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: front-end
  namespace: question06
spec:
  replicas: 4
  selector:
    matchLabels:
      app: deployment-rs
  template:
    metadata:
      labels:
        app: deployment-rs
        environment: dev
    spec:
      containers:
      - name: nginx
        image: r.deso.tech/dockerhub/library/nginx
EOF
)

echo "$manifest_content" | kubectl apply -f - > /dev/null 2>&1
