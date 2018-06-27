# openshift-origin-vagrant

Please, find the original post from [Bernd](https://github.com/berndonline) and explanation of the environment [here](https://techbloc.net/archives/2581). This is a fork from [his repo](https://github.com/berndonline/openshift-origin-vagrant) where I tried to automate everything so you don't have to do multiple steps to have your OpenShift running on KVM.

Running `centos-setup.sh` will install all the needed requirements, including cloning this repository and the Ansible one.
It is not supposed to run on this directory but to bootstrap the cluster by executing:

    curl https://raw.githubusercontent.com/chmeee/openshift-origin-vagrant/master/centos-setup.sh | bash - 

Running `origin-cluster-up.sh` will:
  * Clone the OpenShift Ansible repository if you haven't done so
  * Create the machines (you can select how much memory and how many nodes in the `Vagrantfile`)
  * Generate a `inventory` file from the `inventory-template` (Origin verion 3.7.2, `ovs-multitenant` network plugin and `xip.io` as domain are used by default, change it to fit your needs)
  * Launch the ansible playbook from the OpenShift Ansible [repository](https://github.com/openshift/openshift-ansible)
  * Copy the admin.kubeconfig file to access the OCP cluster as admin using `oc` from your local machine

The `inventory-template` file will not install `metrics` and `logging` by default.

## Known issues

ASB is not starting.
After `vagrant halt` and `vagrant up` not all services/pods are started.

Metrics and logging do not start completely.

In any case, for `metrics` you need, on the local computer:
  * java
  * python-passlib
  * htpasswd (package `httpd-tools` on rpm-based linux, `apache-tools` on AUR)
