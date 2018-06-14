#!/bin/bash

NODECOUNT=$(grep ^NODECOUNT= Vagrantfile | cut -f2 -d=)

EXIT=0

for role in master etcd infra; do
  vagrant up origin-$role --color <<< 'boot' || EXIT=$?
done

for n in $(seq 1 $NODECOUNT); do
  vagrant up origin-node-$n --color <<< 'boot' || EXIT=$?
done

if [ $EXIT != 0 ]; echo "Vagrant error, no inventory file will be created"; exit $EXIT; fi

MASTERIP=$(vagrant ssh-config origin-master | grep -Po '\d+\.\d+\.\d+\.\d+')

sed -e "s#USERHOME#$HOME#;
	s#MASTERIP#$MASTERIP#;
	s#NODECOUNT#$NODECOUNT#" inventory-template > inventory

exit $EXIT
