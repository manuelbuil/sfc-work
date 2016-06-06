nsp=`ovs-ofctl -O Openflow13 dump-flows br-int | grep table=11, | awk '/ nsp/' | awk '{print $6}' | awk -F ',' '{print $1}' | awk -F '=' '{print $2}'`
output_port=`ovs-ofctl -O Openflow13 dump-flows br-int | grep table=11, | awk '/>nsp/' | awk -F ':' '{print $NF}'`
ip=ovs-ofctl -O Openflow13 dump-flows br-int | grep table=158, | awk '/nshc1/' | awk -F ',' '{print $8}' | awk -F '=' '{print $2}'
sf_port=ovs-ofctl -O Openflow13 dump-flows br-int | grep table=0, | awk '/in_port=/' | awk -F ',' '{print $8}' | awk -F '=' '{print $NF}'

ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=80"
ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=80,priority=5 actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],set_field:$ip-->nshc1,set_field:$nsp->nsp,set_field:255->nsi,load:0xc0a80003->NXM_NX_TUN_IPV4_DST[],load:0x97->NXM_NX_TUN_ID[0..31],resubmit($output_port,0)"
ovs-ofctl -O Openflow13 add-flow br-int "table=0,priority=405,udp,in_port=$sf_port,tp_dst=6633 actions=LOCAL"
