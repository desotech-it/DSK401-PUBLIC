#!/bin/bash

export location=/home/student/CKA-material
export question=question-44
export folder=folder-44
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


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-44/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/pets.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: pets
EOF

kubectl apply -f $location/$folder/pets.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/pets.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/hamster.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: hamster
  namespace: pets
EOF

kubectl apply -f $location/$folder/hamster.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/hamster.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/hamster-cluterrole.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: hamster
  namespace: pets
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list"]
EOF

kubectl apply -f $location/$folder/hamster-cluterrole.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/hamster-cluterrole.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/hamster-rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: hamster
  namespace: pets
subjects:
- kind: ServiceAccount
  name: hamster
  namespace: pets
roleRef:
  kind: ClusterRole
  name: hamster
  apiGroup: rbac.authorization.k8s.io
EOF

kubectl apply -f $location/$folder/hamster-rolebinding.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/hamster-rolebinding.yaml >> $LOGFILE 2>&1 