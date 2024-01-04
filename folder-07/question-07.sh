#!/bin/bash

export location=/home/student/CKA-material
export question=question-07
export folder=folder-07
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


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-07/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/meet-up.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: meet-up
EOF

kubectl apply -f $location/$folder/meet-up.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/meet-up.yaml >> $LOGFILE 2>&1 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/presentation.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: presentation
  namespace: meet-up
  labels:
    qreplica: three
    project: exposing
spec:
  selector:
    matchLabels:
      app: deployment-rs
  template:
    metadata:
      labels:
        app: deployment-rs
        environment: dev
        replica: three
        project: exposing
    spec:
      containers:
      - name: whoami
        image: r.deso.tech/whoami/whoami
  replicas: 15
EOF


kubectl apply -f $location/$folder/presentation.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/presentation.yaml >> $LOGFILE 2>&1 