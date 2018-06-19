# openshift-origin-vagrant

Please, find instructions [here](https://techbloc.net/archives/2581).

Now, running `vagrant_up.sh` will:
  * Create the machines (you can select how much memory and how many nodes in the `Vagrantfile`)
  * Generate a `inventory` file from the `inventory-template` (Origin verion 3.7.2, `ovs-multitenant` network plugin and `xip.io` as domain are used by default, change it to fit your needs)
  * Launch the ansible playbook from the OpenShift Ansible [repository](https://github.com/openshift/openshift-ansible), which you should have cloned in the same base directory as this one.
  * Copy the admin.kubeconfig file to access the OCP cluster as admin from `oc`.

The `inventory-template` file will install `metrics` and `logging` by default.
For `metrics` you need:
  * java
  * python-passlib
  * htpasswd (package `httpd-tools` on rpm-based linux, `apache-tools` on AUR)

## Known issues

At least with 2G mem, ASB is not starting.

After `vagrant halt` and `vagrant up` not all services/pods are started.
