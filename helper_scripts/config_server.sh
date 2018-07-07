#!/usr/bin/env bash

mkdir /home/vagrant/bin

cat << 'END' > /home/vagrant/bin/ovs-vsctl
#!/usr/bin/env bash

sudo docker exec -ti openvswitch $(basename $0) $@
END

ln /home/vagrant/bin/ovs-{vsctl,appctl}
ln /home/vagrant/bin/ovs-{vsctl,ofctl}
