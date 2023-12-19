#!/bin/bash

manifest_content=$(cat <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: web-app
---
apiVersion: v1
kind: Service
metadata:
  name: headless-svc
  namespace: web-app
spec:
  ports:
    - name: http
      port: 80
  selector:
    app: nginx
  clusterIP: None
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
  namespace: web-app
spec:
  serviceName: headless-svc
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: httpserver
          image: r.deso.tech/dockerhub/library/nginx
          volumeMounts:
          - name:  data
            mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes:
      - ReadWriteMany
      resources:
        requests:
          storage: 1Gi
      storageClassName: nfs-client
EOF
)

echo "$manifest_content" | kubectl apply -f - > /dev/null 2>&1

kubectl wait --for=condition=Ready statefulset/web --timeout=60s -n web-app > /dev/null 2>&1
