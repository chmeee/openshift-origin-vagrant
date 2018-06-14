#!/bin/bash

NODECOUNT=$(grep ^NODECOUNT= Vagrantfile | cut -f2 -d=)

EXIT=0

for role in master etcd infra; do
  vagrant up origin-$role --color <<< 'boot' || EXIT=$?
done

for n in $(seq 1 $NODECOUNT); do
  vagrant up origin-node-$n --color <<< 'boot' || EXIT=$?
done

MASTERIP=$(vagrant ssh-config origin-master | grep -Po '\d+\.\d+\.\d+\.\d+')

sed -i "s#USERHOME#$HOME#" inventory
sed -i "s#MASTERIP#$MASTERIP#" inventory
sed -i "s#NODECOUNT#$NODECOUNT#" inventory

exit $EXIT
