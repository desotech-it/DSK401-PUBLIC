#!/bin/bash

manifest_content=$(cat <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: project-hamster
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: secret-reader
  namespace: project-hamster
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: secret-reader-role
  namespace: project-hamster
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: secret-reader-binding
  namespace: project-hamster
subjects:
- kind: ServiceAccount
  name: secret-reader
  namespace: project-hamster
roleRef:
  kind: Role
  name: secret-reader-role
  apiGroup: rbac.authorization.k8s.io
EOF
)

echo "$manifest_content" | kubectl apply -f - > /dev/null 2>&1
