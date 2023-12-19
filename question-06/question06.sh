#!/bin/bash

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
