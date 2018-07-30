#!/usr/bin/env bash

## Install network analysis tools
yum install -y tcpdump wireshark nmap-ncat net-tools docker
systemctl start docker

## Add vagrant to wireshark group
usermod -a -G wireshark vagrant

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
ln /home/vagrant/bin/ovs-{vsctl,dpctl}

chmod 755 /home/vagrant/bin/ovs-*

## If etcd, stop here
if hostname | grep -q etcd; then
  exit 0;
fi

## Install these three nuage images in every node
for img in vrs infra cni; do
  docker load -i /vagrant/docker_images/nuage-${img}-docker*.tar
done

## Install the nuage-master-docker image only in master nodes
if hostname | grep -q master; then
  docker load -i /vagrant/docker_images/nuage-master-docker*.tar
fi
