#!/bin/bash

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
