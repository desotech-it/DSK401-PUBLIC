#!/bin/bash

export location=/home/student/CKA-material
export question=question-13
export folder=folder-13
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


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-13/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
kubectl create ns sandwich  >> $LOGFILE 2>&1


manifest_content=$(cat <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: question13
---
apiVersion: v1
kind: Pod
metadata:
  name: busybox-logger
  namespace: question13
spec:
  containers:
  - name: busybox-container
    image: r.deso.tech/dockerhub/library/busybox
    args:
    - /bin/sh
    - -c
    - while true; do date >> /var/log/big-corp-app.log; sleep 4; done
    volumeMounts:
    - name: log-volume
      mountPath: /var/log
  volumes:
  - name: log-volume
    emptyDir: {}
EOF
)

echo "$manifest_content" | kubectl apply -f - > /dev/null 2>&1
