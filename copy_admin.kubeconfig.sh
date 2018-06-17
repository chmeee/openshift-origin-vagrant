#!/usr/bin/env bash

vagrant ssh origin-master -c 'sudo cat /etc/origin/master/admin.kubeconfig' > admin.kubeconfig

echo # Execute the following to have oc configured with the openshift cluster for this shell
echo # Next time you can also eval this script
echo export KUBECONFIG=$PWD/admin.kubeconfig
