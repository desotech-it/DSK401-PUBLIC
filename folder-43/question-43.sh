43#!/bin/bash

export location=/home/student/CKA-material
export question=question-43
export folder=folder-43
export LOGFILE=$question.log
touch $LOGFILE >> $LOGFILE 2>&1

./tools/cleanup.sh  >> $LOGFILE 2>&1

cat <<EOF | kind create cluster --image kindest/node:v1.29.0@sha256:eaa1450915475849a73a9227b8f201df25e55e268e5d619312131292e324d570  --config - > /dev/null 2>&1
kind: Cluster
name: $question
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  podSubnet: "10.199.0.0/16"
  serviceSubnet: "10.200.0.0/16"
nodes:
- role: control-plane
- role: worker
- role: worker
EOF


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-43/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
 

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
