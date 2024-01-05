#!/bin/bash

git clone --depth=1 https://github.com/desotech-it/DSK401-public.git -b 1.28-dev >> /dev/null 2>&1 

mv DSK401-public CKA-material >> /dev/null 2>&1 

cd CKA-material >> /dev/null 2>&1 

chmod +x tools/*.sh


for q in {00..60} ; do chmod +x folder-"$q"/*.sh ; done >> /dev/null 2>&1 





cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/ns.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: project-hamster
EOF

kubectl apply -f $location/$folder/ns.yaml >> $LOGFILE 2>&1 

rm -f $location/$folder/ns.yaml >> $LOGFILE 2>&1 