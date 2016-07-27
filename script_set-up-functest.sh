function proxy () {
        export https_proxy=http://10.87.68.86:8080
        export http_proxy=http://10.87.68.86:8080
        export no_proxy=127.0.0.1,240.0.0.1,172.16.0.3,10.20.0.8,192.168.2.2,192.168.0.2,192.168.1.1,192.168.0.4,10.20.0.2,192.168.0.3
        echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCf98Nq3A7ptf4DrW7hrUiBAqTVuZebQvHKcWLfDGMy/RG+nhCHwUjUYR0m9qULD/HUm4m1AuSKGudqySqI+y7f4VwPpg0eUTvAYWb3ijc0zVJS3osRnve333id0n3ithGTsPI2WM57ItEVw6rwwzBj51GSTGujnqNFQrbM75LNU8dII/NlP2mydEiAqAK4kJHApUSaeB2WbI9edYPWNcnnQmnjkx+Zdvvby5EgNnpKdOuWlRqlIKS39FBVavA+U22sxEhJLkm5vVhTEeo/fclMT4D91iO+9TG6+0loy6Ux/N1PpSN8+P+GO+Ra+5jqUNIy55cjTdJuBAvIbgJ6M2UZ root@dl360-228" >> ~/.ssh/authorized_keys
}

function no_proxy () {
        export https_proxy=
        export http_proxy=
}

if [ "$1" == "proxy" ]; then
        proxy
fi
apt-get install git -y
git clone https://gerrit.opnfv.org/gerrit/fuel
pushd fuel
git fetch https://gerrit.opnfv.org/gerrit/fuel refs/changes/65/15065/5 && git checkout FETCH_HEAD
popd
mv fuel/prototypes/sfc_tacker/poc.tacker-up.sh .
echo `pwd`
echo `ls`
sleep 3
bash poc.tacker-up.sh

touch delete.sh

echo "
tacker sfc-classifier-delete red_http
tacker sfc-classifier-delete blue_ssh
tacker sfc-classifier-delete red_ssh
tacker sfc-classifier-delete blue_http
tacker sfc-delete red
tacker sfc-delete blue
tacker vnf-delete testVNF1
tacker vnf-delete testVNF2
tacker vnfd-delete test-vnfd1 
tacker vnfd-delete test-vnfd2
#openstack stack delete sfc --y
heat stack-delete sfc
#openstack stack delete sfc_test1 --y
heat stack-delete sfc_test1
#openstack stack delete sfc_test2 --y
heat stack-delete sfc_test2
" >> delete.sh

chmod +x delete.sh

source tackerc
openstack flavor create custom --ram 1500 --disk 10 --public

#Temporarily, while we introduce the vxlan_tool.py in the image
git clone https://git.opendaylight.org/gerrit/sfc
cd sfc
git fetch https://git.opendaylight.org/gerrit/sfc refs/changes/33/41533/2 && git checkout FETCH_HEAD
