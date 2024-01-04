#!/bin/bash

export location=/home/student/CKA-material
export question=question-14
export folder=folder-14
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


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-14/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
 
touch /home/student/CKA-material/folder-14/14-podcpu.txt

./metricserver-install.sh >> $LOGFILE 2>&1

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/low-resource.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: low-resource
EOF

kubectl apply -f $location/$folder/low-resource.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/low-resource.yaml >> $LOGFILE 2>&1 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/experience.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: experience
EOF

kubectl apply -f $location/$folder/experience.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/experience.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/webserver.yaml
apiVersion: v1
kind: Pod
metadata:
  name: chipcken
  namespace: experience
spec:
  containers:
  - name: bigcorp-container
    image: r.deso.tech/dockerhub/library/nginx
EOF

kubectl apply -f $location/$folder/chipcken.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/chipcken.yaml >> $LOGFILE 2>&1 



cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/webserver.yaml
apiVersion: v1
kind: Pod
metadata:
  name: webserver1
  namespace: low-resource
  labels:
    name: overloaded-cpu
spec:
  containers:
  - name: bigcorp-container
    image: r.deso.tech/dockerhub/library/nginx
EOF

kubectl apply -f $location/$folder/webserver.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/webserver.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/webserver.yaml
apiVersion: v1
kind: Pod
metadata:
  name: webserver2
  namespace: low-resource
  labels:
    name: overloaded-cpu
spec:
  containers:
  - name: bigcorp-container
    image: r.deso.tech/dockerhub/library/nginx
EOF

kubectl apply -f $location/$folder/webserver.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/webserver.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/webserver.yaml
apiVersion: v1
kind: Pod
metadata:
  name: webserver3
  namespace: low-resource
  labels:
    name: overloaded-cpu
spec:
  containers:
  - name: bigcorp-container
    image: r.deso.tech/dockerhub/library/nginx
EOF

kubectl apply -f $location/$folder/webserver.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/webserver.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/presentation.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: presentation
  namespace: meet-up
  labels:
    qreplica: three
    project: exposing
spec:
  replicas: 1
  selector:
    matchLabels:
      app: deployment-rs
  template:
    metadata:
      labels:
        app: deployment-rs
        environment: dev
        replica: three
        project: exposing
        name: overloaded-cpu
    spec:
      containers:
      - name: whoami
        image: r.deso.tech/whoami/whoami
EOF


kubectl apply -f $location/$folder/presentation.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/presentation.yaml >> $LOGFILE 2>&1 