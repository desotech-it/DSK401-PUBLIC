#!/bin/bash

export location=/home/student/CKA-material
export question=question-35
export folder=folder-35
export LOGFILE=$question.log
touch $LOGFILE >> $LOGFILE 2>&1

./cleanup.sh >> $LOGFILE 2>&1

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


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-35/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
kubectl create ns sandwich  >> $LOGFILE 2>&1


# Specifica le variabili per l'accesso SSH
SSH_HOST="worker01"

# Esegui comandi remoti tramite SSH
ssh $SSH_HOST << EOF
  # Backup della configurazione originale
  sudo cp /etc/systemd/system/kubelet.service.d/10-kubeadm.conf /etc/systemd/system/kubelet.service.d/10-kubeadm.conf.bak

  # Modifica del percorso del binario di kubelet
  sudo sed -i 's@/usr/bin/kubelet@/path/to/nonexistent/kubelet@g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

  # Ricarica la configurazione del servizio
  sudo systemctl daemon-reload

  # Riavvia kubelet
  sudo systemctl restart kubelet
EOF
