#!/usr/bin/env bash

if ! grep -qE '(vmx|svm)' /proc/cpuinfo; then
  echo "This computer's CPU doesn't seem to support virtualization."
  exit 1
fi

EXIT=0

echo "##"
echo "## Installing git"
echo "##"
yum -y install git || EXIT=$?

if [[ $EXIT != 0 ]]; then "Something went wrong, exiting..."; exit $EXIT; fi

echo "##"
echo "## Installing KVM"
echo "##"

echo "## installing the required software packages"
yum install -y qemu-kvm qemu-img virt-manager libvirt libvirt-python libvirt-client virt-install virt-viewer bridge-utils || EXIT=$?

if [[ $EXIT != 0 ]]; then "Something went wrong, exiting..."; exit $EXIT; fi

echo "## Enabling and starting libvirtd"
systemctl enable libvirtd
systemctl start libvirtd

if ! lsmod | grep -q kvm; then
  echo "Something went wrong, KVM module is not installed on the kernel"
  exit 1
fi

echo "##"
echo "## Installing Ansible"
echo "##"
yum install -y ansible ansible-doc || EXIT=$?

if [[ $EXIT != 0 ]]; then "Something went wrong, exiting..."; exit $EXIT; fi

echo "##"
echo "## Installing Vagrant"
echo "##"
yum install -y https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_x86_64.rpm || EXIT=$?

if [[ $EXIT != 0 ]]; then "Something went wrong, exiting..."; exit $EXIT; fi

echo "## Installing libvirt Vagrant plugin dependencies"
yum install -y libvirt-devel ruby-devel gcc || EXIT=$?

if [[ $EXIT != 0 ]]; then "Something went wrong, exiting..."; exit $EXIT; fi

echo "## Installing libvirt Vagrant plugin"
vagrant plugin install vagrant-libvirt || EXIT=$?

if [[ $EXIT != 0 ]]; then "Something went wrong, exiting..."; exit $EXIT; fi

echo "## Installing hostmanager Vagrant plugin"
vagrant plugin install vagrant-hostmanager || EXIT=$?

if [[ $EXIT != 0 ]]; then "Something went wrong, exiting..."; exit $EXIT; fi

echo "##"
echo "## Cloning the OpenShift Ansible repository from Github"
echo "##"
git clone https://github.com/openshift/openshift-ansible.git || EXIT=$?

if [[ $EXIT != 0 ]]; then "Something went wrong, exiting..."; exit $EXIT; fi

echo "##"
echo "## Cloning the OpenShift Origin Vagrant repository from Github"
echo "##"
git clone https://github.com/chmeee/openshift-origin-vagrant.git || EXIT=$?

if [[ $EXIT != 0 ]]; then "Something went wrong, exiting..."; exit $EXIT; fi

echo "##"
echo "## Setup finished. Now you can cd to openshift-origin-vagrant"
echo "## Edit the Vagrantfile to personalize number of nodes and memory"
echo "## And build and start the cluster running ./origin-cluster-up.sh"
