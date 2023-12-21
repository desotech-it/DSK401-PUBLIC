#!/bin/bash

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
