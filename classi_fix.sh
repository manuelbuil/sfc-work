
ip=c0a80022
nsp=0x178
output_port=6


ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=80"
ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=22"
ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=22 actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],set_field:0x$ip->nshc1,set_field:$nsp->nsp,set_field:255->nsi,load:0x$ip->NXM_NX_TUN_IPV4_DST[],load:$nsp->NXM_NX_TUN_ID[0..31],resubmit($output_port,0)"
