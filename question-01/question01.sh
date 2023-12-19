#!/bin/bash

manifest_content=$(cat <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: question-01
---
apiVersion: v1
kind: Namespace
metadata:
  name: app-team1
EOF
)

echo "$manifest_content" | kubectl apply -f - > /dev/null 2>&1
