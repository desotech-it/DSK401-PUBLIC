#!/bin/bash

# Nome del nodo da verificare
NODE_NAME="worker01"

# Esegui l'uncordon sul nodo
kubectl uncordon "$NODE_NAME" > /dev/null