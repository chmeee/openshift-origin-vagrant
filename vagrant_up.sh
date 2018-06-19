#!/usr/bin/env bash

NODECOUNT=$(grep ^NODECOUNT= Vagrantfile | cut -f2 -d=)

# If you have different node memory sizes, you'll need to set this option manually to the least
MEMORY=$(( $(grep ^MEMORY= Vagrantfile | cut -f2 -d=) / 1024 ))

EXIT=0

echo "##"
echo "## Creating the machines for the cluster"
echo "##"
for role in master etcd infra; do
  vagrant up origin-$role --color <<< 'boot' || EXIT=$?
  if [[ $EXIT != 0 ]]; then echo "Vagrant up error, no inventory file will be created (exit code $EXIT)"; exit $EXIT; fi
done

for n in $(seq 1 $NODECOUNT); do
  vagrant up origin-node-$n --color <<< 'boot' || EXIT=$?
  if [[ $EXIT != 0 ]]; then echo "Vagrant up error, no inventory file will be created (exit code $EXIT)"; exit $EXIT; fi
done

echo "##"
echo "## Getting the IP address for master and infra nodes for the cluster"
echo "##"
MASTERIP=$(vagrant ssh-config origin-master | grep -Po '\d+\.\d+\.\d+\.\d+')
INFRAIP=$(vagrant ssh-config origin-infra | grep -Po '\d+\.\d+\.\d+\.\d+')

if [[ -z $MASTERIP || -z $INFRAIP ]]; then echo "Couldn't get master or infra IP, no inventory file will be created"; exit 1; fi

echo "##"
echo "## Generating the Ansible inventory from the template"
echo "##"
sed -e "s#USERHOME#$HOME#;
	s#MEMORY#$MEMORY#;
	s#MASTERIP#$MASTERIP#;
	s#INFRAIP#$INFRAIP#;
	s#NODECOUNT#$NODECOUNT#" inventory-template > inventory

EXIT=0

echo "##"
echo "## Running the Ansible playbooks for OpenShift"
echo "##"
cd ../openshift-ansible
ansible-playbook ./playbooks/byo/config.yml -i ../openshift-origin-vagrant/inventory || EXIT=$?

if [[ $EXIT != 0 ]]; then echo "Ansible error (exit code $EXIT)"; exit $EXIT; fi

EXIT=0

echo "##"
echo "## Copying the admin.kubeconfig file from master"
echo "##"
cd -
vagrant ssh origin-master -c 'sudo cat /etc/origin/master/admin.kubeconfig' > admin.kubeconfig

if [[ $EXIT != 0 ]]; then echo "Error copying the admin.kubeconfig file (exit code $EXIT)"; exit $EXIT; fi

echo "# Execute the following to have oc configured with the openshift cluster for this shell"
echo "# Next time you can also eval this script"
echo "export KUBECONFIG=$PWD/admin.kubeconfig"
