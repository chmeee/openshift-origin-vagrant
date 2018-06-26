#!/usr/bin/env bash

if ! grep -qE '(vmx|svm)' /proc/cpuinfo; then
  echo "This computer's CPU doesn't seem to support virtualization."
  exit 1
fi

echo "##"
echo "## Installing git"
echo "##"
yum -y install git

echo "##"
echo "## Installing KVM"
echo "##"

echo "## installing the required software packages"
yum install -y qemu-kvm qemu-img virt-manager libvirt libvirt-python libvirt-client virt-install virt-viewer bridge-utils

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
yum install -y ansible ansible-doc

echo "##"
echo "## Installing Vagrant"
echo "##"
yum install -y https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_x86_64.rpm

echo "## Installing libvirt Vagrant plugin dependencies"
yum install -y libvirt-devel ruby-devel gcc

echo "## Installing libvirt Vagrant plugin"
vagrant plugin install vagrant-libvirt

echo "## Installing hostmanager Vagrant plugin"
vagrant plugin install vagrant-hostmanager
