#!/bin/bash

# Nome del nodo da verificare
NODE_NAME="worker01"

# Ottieni lo stato del nodo
NODE_STATUS=$(kubectl get nodes "$NODE_NAME" -o=jsonpath='{.status.conditions[?(@.type=="Ready")].status}')

# Verifica lo stato del nodo
if [ "$NODE_STATUS" != "True" ]; then
    # Esegui l'uncordon sul nodo
    kubectl uncordon "$NODE_NAME" > /dev/null
fi
