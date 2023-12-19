#!/bin/bash

manifest_content=$(cat <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: question07
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: presentation
  namespace: question07
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
      - name: whoami
        image: r.deso.tech/whoami/whoami
)

echo "$manifest_content" | kubectl apply -f - > /dev/null 2>&1
