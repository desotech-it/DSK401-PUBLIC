#!/bin/bash

export location=/home/student/CKA-material
export question=question-41
export folder=folder-41
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


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-41/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/snake.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: snake
EOF

kubectl apply -f $location/$folder/snake.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/snake.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/pod-01.yaml
apiVersion: v1
kind: Pod
metadata:
  name: backend-0
  namespace: snake
  labels:
    app: backend
spec:
  containers:
    - name: whoami
      image: r.deso.tech/whoami/whoami
EOF

kubectl apply -f $location/$folder/pod-01.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/pod-01.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/pod-02.yaml
apiVersion: v1
kind: Pod
metadata:
  name: db1-0
  namespace: snake
  labels:
    app: db1
spec:
  containers:
    - name: whoami
      image: r.deso.tech/whoami/whoami
EOF

kubectl apply -f $location/$folder/pod-02.yaml >> $LOGFILE 2>&1 


rm -f $location/$folder/pod-02.yaml >> $LOGFILE 2>&1 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/pod-03.yaml
apiVersion: v1
kind: Pod
metadata:
  name: db2-0
  namespace: snake
  labels:
    app: db2
spec:
  containers:
    - name: whoami
      image: r.deso.tech/whoami/whoami
EOF

kubectl apply -f $location/$folder/pod-03.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/pod-03.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/pod-04.yaml
apiVersion: v1
kind: Pod
metadata:
  name: vault-0
  namespace: snake
  labels:
    app: vault
spec:
  containers:
    - name: whoami
      image: r.deso.tech/whoami/whoami
EOF

kubectl apply -f $location/$folder/pod-04.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/pod-04.yaml >> $LOGFILE 2>&1 

