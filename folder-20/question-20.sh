#!/bin/bash

export location=/home/student/CKA-material
export question=question-20
export folder=folder-20
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


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-20/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
 
cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/meet-up.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: web-app
EOF

kubectl apply -f $location/$folder/meet-up.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/meet-up.yaml >> $LOGFILE 2>&1 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/svc.yaml
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
EOF

kubectl apply -f $location/$folder/svc.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/svc.yaml >> $LOGFILE 2>&1 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/sts-up.yaml
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

kubectl apply -f $location/$folder/sts-up.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/sts-up.yaml >> $LOGFILE 2>&1 

kubectl wait --for=condition=Ready statefulset/web --timeout=60s -n web-app > /dev/null 2>&1
