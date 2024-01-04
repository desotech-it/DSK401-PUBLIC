#!/bin/bash

export location=/home/student/CKA-material
export question=question-17
export folder=folder-17
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


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-17/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
kubectl create ns sandwich  >> $LOGFILE 2>&1


manifest_content=$(cat <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: question17
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: phippy
    version: "1.0"
  name: phippy
  namespace: question17
spec:
  replicas: 1
  selector:
    matchLabels:
      app: phippy
      version: "1.0"
  strategy: {}
  template:
    metadata:
      labels:
        app: phippy
        version: "1.0"
    spec:
      containers:
      - image: r.deso.tech/whoami/whoami
        name: phippy
        ports:
        - containerPort: 80
        resources: {}
        env:
        - name: NAME_APPLICATION
          value: "phippy"
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: phippy
    version: "1.0"
  name: phippy
  namespace: question17
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: phippy
    version: "1.0"
  type: ClusterIP
status:
  loadBalancer: {}
EOF
)

echo "$manifest_content" | kubectl apply -f - > /dev/null 2>&1
