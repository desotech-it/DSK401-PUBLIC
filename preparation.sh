#!/bin/bash

git clone --depth=1 https://github.com/desotech-it/DSK401-public.git -b 1.28-dev >> /dev/null 2>&1 

mv DSK401-public CKA-material >> /dev/null 2>&1 

cd CKA-material >> /dev/null 2>&1 

chmod +x cleanup.sh

for q in {00..58} ; do chmod +x folder-"$q"/*.sh ; done >> /dev/null 2>&1 
