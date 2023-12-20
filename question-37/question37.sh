#!/bin/bash

# Stacca il nodo dal cluster
kubectl drain worker02 --ignore-daemonsets --delete-emptydir-data > /dev/null 2>&1

# Rimuovi il nodo dal cluster
kubectl delete node worker02 > /dev/null 2>&1