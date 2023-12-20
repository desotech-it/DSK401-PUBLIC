#!/bin/bash

manifest_content=$(cat <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: question27
apiVersion: v1
kind: Namespace
metadata:
  name: project-hamster
EOF
)

echo "$manifest_content" | kubectl apply -f - > /dev/null 2>&1
