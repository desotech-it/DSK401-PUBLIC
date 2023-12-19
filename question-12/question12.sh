#!/bin/bash

manifest_content=$(cat <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: question12
---
apiVersion: v1
kind: Pod
metadata:
  name: foo
  namespace: question12
spec:
  containers:
    - name: container01
      image: r.deso.tech/dsk/dsutils:latest
      command:
        - "/bin/sh"
        - "-c"
        - "ping -c 5 8.8.8.8 && ls /non/existent/file && ping -c 10 127.0.0.1"
EOF
)

echo "$manifest_content" | kubectl apply -f - > /dev/null 2>&1
