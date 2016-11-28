#!/bin/bash

for i in $(neutron security-group-list | grep default | cut -d"|" -f2)
do
neutron security-group-rule-create --direction ingress --ethertype IPv4 --protocol udp --port-range-min 53 --port-range-max 53 $i
done
ip_client=$(nova list | grep client | cut -d"|" -f7 | cut -d" " -f3)
ssh_options='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
sshpass -p opnfv scp $ssh_options setup-vncserver.sh root@$ip_client:/root
sshpass -p opnfv ssh $ssh_options root@$ip_client "bash setup-vncserver.sh"
