#!/usr/bin/env bash

NODECOUNT=$(grep ^NODECOUNT= Vagrantfile | cut -f2 -d=)

# If you have different node memory sizes, you'll need to set this option manually to the least
MEMORY=$(( $(grep ^MEMORY= Vagrantfile | cut -f2 -d=) / 1024 ))

EXIT=0

for role in master etcd infra; do
  vagrant up origin-$role --color <<< 'boot' || EXIT=$?
done

for n in $(seq 1 $NODECOUNT); do
  vagrant up origin-node-$n --color <<< 'boot' || EXIT=$?
done

if [[ $EXIT != 0 ]]; then echo "Vagrant up error, no inventory file will be created"; exit $EXIT; fi

MASTERIP=$(vagrant ssh-config origin-master | grep -Po '\d+\.\d+\.\d+\.\d+')

if [[ -z $MASTERIP ]]; then echo "Couldn't get master IP, no inventory file will be created"; exit $EXIT; fi

sed -e "s#USERHOME#$HOME#;
	s#MEMORY#$MEMORY#;
	s#MASTERIP#$MASTERIP#;
	s#NODECOUNT#$NODECOUNT#" inventory-template > inventory
