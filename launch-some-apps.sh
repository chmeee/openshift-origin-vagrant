#!/usr/bin/env bash

if [[ $# != 1 ]]; then
  echo "Error: needs one argument"
  echo "Syntax: $0 number-of-projects"
  exit 1
fi

NUMPROJ=$1

oc login -u demo -p demo

for p in $(seq -w 1 $NUMPROJ); do
  oc new-project test$p
  oc project test$p
  # node app
  oc new-app https://github.com/openshift/nodejs-ex -l name=node$p
  oc expose svc/nodejs-ex
  # ruby app
  oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git -l name=ruby$p
  oc expose svc/ruby-ex
done
