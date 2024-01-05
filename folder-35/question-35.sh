#!/bin/bash

export location=/home/student/CKA-material
export question=question-35
export folder=folder-35
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
EOF


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-35/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1

docker exec $question-worker systemctl stop kubelet >> $LOGFILE 2>&1
sleep 20  >> $LOGFILE 2>&1

alias ssh='function _run () { docker exec -it "$1" /bin/bash; }; _run' >> $LOGFILE 2>&1