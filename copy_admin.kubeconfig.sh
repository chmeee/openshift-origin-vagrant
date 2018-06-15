#!/usr/bin/env bash

MASTERIP=$(vagrant ssh-config origin-master | grep -Po '\d+\.\d+\.\d+\.\d+')

if [[ -z $MASTERIP ]]; then echo "Couldn't get master IP, can't copy the admin.kubeconfig file"; exit $EXIT; fi

ssh -i ~/.vagrant.d/insecure_private_key vagrant@10.255.1.158 'sudo cat /etc/origin/master/admin.kubeconfig' > admin.kubeconfig

echo # Execute the following to have oc configured with the openshift cluster for this shell
echo # Next time you can also eval this script
echo export KUBECONFIG=$PWD/admin.kubeconfig
