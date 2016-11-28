#!/bin/bash
apt-get install sshpass
ip_server=$(nova list | grep server | cut -d"|" -f7 | cut -d" " -f3)
ssh_options='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
sshpass -p opnfv scp $ssh_options stockholm.jpg root@$ip_server:/root
