#!/bin/bash

# Nome del nodo
NODE_NAME="worker01"

# Label da aggiungere
LABEL_KEY="scope"
LABEL_VALUE="prod"

# Aggiungi la label al nodo
kubectl label nodes "$NODE_NAME" "$LABEL_KEY"="$LABEL_VALUE" --overwrite &> /dev/null
