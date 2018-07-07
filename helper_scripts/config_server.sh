#!/usr/bin/env bash

## Install network analysis tools
yum install -y tcpdump wireshark

## Convenience script to use ovs commands on the openvswitch container
mkdir /home/vagrant/bin

cat << 'END' > /home/vagrant/bin/ovs-vsctl
#!/usr/bin/env bash

COMMAND=$(basename $0)
ARGS=$@

if [[ $COMMAND == "ovs-ofctl" ]]; then ARGS=${ARGS}" -O OpenFlow13"; fi

sudo docker exec -ti openvswitch $COMMAND $ARGS
END

ln /home/vagrant/bin/ovs-{vsctl,appctl}
ln /home/vagrant/bin/ovs-{vsctl,ofctl}
