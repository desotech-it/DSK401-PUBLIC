#!/bin/bash

export location=/home/student/CKA-material
export question=question-12
export folder=folder-12
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


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-12/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/experimental.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: experimental
EOF

kubectl apply -f $location/$folder/experimental.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/experimental.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/foo.yaml
apiVersion: v1
kind: Pod
metadata:
  name: foo
  namespace: experimental
spec:
  containers:
    - name: container01
      image: r.deso.tech/dsk/dsutils:latest
      command:
        - "/bin/sh"
        - "-c"
        - "ping -c 5 8.8.8.8 && ls /non/existent/file && ping -c 10 127.0.0.1"
EOF

kubectl apply -f $location/$folder/foo.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/foo.yaml >> $LOGFILE 2>&1 
