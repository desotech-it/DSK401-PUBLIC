#!/bin/bash

manifest_content=$(cat <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: project-c13
EOF
)

echo "$manifest_content" | kubectl apply -f - > /dev/null 2>&1
