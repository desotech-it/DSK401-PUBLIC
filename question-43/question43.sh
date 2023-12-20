#!/bin/bash

manifest_content=$(cat <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: project-c13
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: c13-2x3-api
  namespace: project-c13
spec:
  replicas: 3
  selector:
    matchLabels:
      app: c13-2x3-api
  template:
    metadata:
      labels:
        app: c13-2x3-api
    spec:
      containers:
      - name: api
        image: r.deso.tech/dockerhub/library/nginx
        resources:
          requests:
            cpu: "50m"
            memory: "20Mi"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: c13-2x3-web
  namespace: project-c13
spec:
  replicas: 4
  selector:
    matchLabels:
      app: c13-2x3-web
  template:
    metadata:
      labels:
        app: c13-2x3-web
    spec:
      containers:
      - name: web
        image: r.deso.tech/dockerhub/library/nginx
        resources:
          requests:
            cpu: "50m"
            memory: "10Mi"

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: c13-3cc-runner
  namespace: project-c13
spec:
  replicas: 2
  selector:
    matchLabels:
      app: c13-3cc-runner
  template:
    metadata:
      labels:
        app: c13-3cc-runner
    spec:
      containers:
      - name: runner
        image: r.deso.tech/dockerhub/library/nginx
        resources:
          requests:
            cpu: "30m"
            memory: "10Mi"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: c13-3cc-runner-heavy
  namespace: project-c13
spec:
  replicas: 3
  selector:
    matchLabels:
      app: c13-3cc-runner-heavy
  template:
    metadata:
      labels:
        app: c13-3cc-runner-heavy
    spec:
      containers:
      - name: runner-heavy
        image: r.deso.tech/dockerhub/library/nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: c13-3cc-web
  namespace: project-c13
spec:
  replicas: 1
  selector:
    matchLabels:
      app: c13-3cc-web
  template:
    metadata:
      labels:
        app: c13-3cc-web
    spec:
      containers:
      - name: web
        image: r.deso.tech/dockerhub/library/nginx
        resources:
          requests:
            cpu: "50m"
            memory: "10Mi"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: o3db
  namespace: project-c13
spec:
  replicas: 2
  selector:
    matchLabels:
      app: o3db
  template:
    metadata:
      labels:
        app: o3db
    spec:
      containers:
      - name: o3db-container
        image: r.deso.tech/dockerhub/library/nginx
EOF
)

echo "$manifest_content" | kubectl apply -f - > /dev/null 2>&1
