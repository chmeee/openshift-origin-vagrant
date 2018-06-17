# openshift-origin-vagrant

Please, find instructions [here](https://techbloc.net/archives/2581).

Now, running `vagrant_up.sh` will:
  * Create the machines (you can select how much memory and how many nodes in the `Vagrantfile`)
  * Generate a `inventory` file from the `inventory-template` (`ovs-multitenant` network plugin is used and `xip.io` as domain, change it to fit your needs)
  * Launch the ansible playbook from the OpenShift Ansible [repository](https://github.com/openshift/openshift-ansible), which you should have cloned in the same base directory as this one.
  * Copy the admin.kubeconfig file to access the OCP cluster as admin from `oc`.
