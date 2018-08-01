#!/usr/bin/env bash

scp ~/.ssh/id_rsa* vsd1:.ssh/
ssh vsd1 /opt/vsd/ejbca/deploy/certMgmt.sh -a generate -u ose-admin -c ose-admin -o openshift -f pem -t client -s root@192.168.122.1:/nuage/nuage_certs/
