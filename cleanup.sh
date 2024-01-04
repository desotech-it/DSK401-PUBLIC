#!/bin/bash
for q in {01..44} ; do kind delete cluster -n question-"$q" ; done >> $LOGFILE 2>&1 

rm -f /home/student/.kube/config >> $LOGFILE 2>&1 

for q in {01..44} ; do rm question-"$q"/*.yaml ; done >> $LOGFILE 2>&1 