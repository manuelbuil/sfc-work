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
git fetch https://gerrit.opnfv.org/gerrit/fuel refs/changes/65/15065/1 && git checkout FETCH_HEAD
popd
mv fuel/prototypes/sfc_tacker/poc.tacker-up.sh .
echo `pwd`
echo `ls`
sleep 3
bash poc.tacker-up.sh
#no_proxy
source tackerc
openstack flavor create custom --ram 1500 --disk 10 --public

echo "
#

# deb cdrom:[Ubuntu-Server 14.04.2 LTS _Trusty Tahr_ - Release amd64 (20150218.1)]/ trusty main restricted

#deb cdrom:[Ubuntu-Server 14.04.2 LTS _Trusty Tahr_ - Release amd64 (20150218.1)]/ trusty main restricted

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://ad.archive.ubuntu.com/ubuntu/ trusty main restricted
deb-src http://ad.archive.ubuntu.com/ubuntu/ trusty main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://ad.archive.ubuntu.com/ubuntu/ trusty-updates main restricted
deb-src http://ad.archive.ubuntu.com/ubuntu/ trusty-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://ad.archive.ubuntu.com/ubuntu/ trusty universe
deb-src http://ad.archive.ubuntu.com/ubuntu/ trusty universe
deb http://ad.archive.ubuntu.com/ubuntu/ trusty-updates universe
deb-src http://ad.archive.ubuntu.com/ubuntu/ trusty-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://ad.archive.ubuntu.com/ubuntu/ trusty multiverse
deb-src http://ad.archive.ubuntu.com/ubuntu/ trusty multiverse
deb http://ad.archive.ubuntu.com/ubuntu/ trusty-updates multiverse
deb-src http://ad.archive.ubuntu.com/ubuntu/ trusty-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://ad.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://ad.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu trusty-security main restricted
deb-src http://security.ubuntu.com/ubuntu trusty-security main restricted
deb http://security.ubuntu.com/ubuntu trusty-security universe
deb-src http://security.ubuntu.com/ubuntu trusty-security universe
deb http://security.ubuntu.com/ubuntu trusty-security multiverse
deb-src http://security.ubuntu.com/ubuntu trusty-security multiverse

## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
# deb http://archive.canonical.com/ubuntu trusty partner
# deb-src http://archive.canonical.com/ubuntu trusty partner

## Uncomment the following two lines to add software from Ubuntu's
## 'extras' repository.
## This software is not part of Ubuntu, but is offered by third-party
## developers who want to ship their latest software.
# deb http://extras.ubuntu.com/ubuntu trusty main
# deb-src http://extras.ubuntu.com/ubuntu trusty main
" >> /etc/apt/sources.list

mv /etc/apt/sources.list.d/* /tmp
apt-get update

sudo apt-get install -y python-virtualenv python-dev
sudo apt-get install -y libffi-dev libssl-dev git

virtualenv ~/yardstick_venv
source ~/yardstick_venv/bin/activate
#proxy

easy_install -U setuptools
git clone https://gerrit.opnfv.org/gerrit/yardstick
cd yardstick
git fetch https://gerrit.opnfv.org/gerrit/yardstick refs/changes/77/14577/13 && git checkout FETCH_HEAD
python setup.py install
source ../tackerc

export EXTERNAL_NETWORK=admin_floating_net
#no_proxy
openstack image create sfc --public --file ../sf_summit2016.qcow2
cp ../sfc-random/test-vnfd.yaml /root/yardstick
sed -i 's/net_mgmt/sfc_test1-sfc-net_mgmt/g' /root/yardstick/test-vnfd.yaml
cp /root/yardstick/test-vnfd.yaml /root/yardstick/test-vnfd1.yaml
cp /root/yardstick/test-vnfd.yaml /root/yardstick/test-vnfd2.yaml
rm /root/yardstick/test-vnfd.yaml

sed -i 's/test-vnfd/test-vnfd1/g' /root/yardstick/test-vnfd1.yaml
sed -i 's/firewall/firewall1/g' /root/yardstick/test-vnfd1.yaml
sed -i 's/test-vnfd/test-vnfd2/g' /root/yardstick/test-vnfd2.yaml
sed -i 's/firewall/firewall2/g' /root/yardstick/test-vnfd2.yaml

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
openstack stack delete sfc --y
openstack stack delete sfc_test1 --y
openstack stack delete sfc_test2 --y
" >> delete.sh

chmod +x delete.sh
export EXTERNAL_NETWORK=admin_floating_net
