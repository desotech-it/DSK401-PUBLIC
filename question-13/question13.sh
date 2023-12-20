#!/bin/bash

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
