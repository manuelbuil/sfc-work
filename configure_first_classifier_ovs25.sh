#client_port=$1
#output_port=$2

nsp=0x126
ip=0xc0a8002b

echo $nsp
echo $ip


ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=80"
ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=22"
#ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=22,in_port=${client_port} actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],set_field:${ip}->nshc1,set_field:${nsp}->nsp,set_field:255->nsi,load:${ip}->NXM_NX_TUN_IPV4_DST[],load:${nsp}->NXM_NX_TUN_ID[0..31],resubmit(${output_port},0)"
#ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=80,in_port=${client_port} actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],set_field:${ip}->nshc1,set_field:${nsp}->nsp,set_field:255->nsi,load:${ip}->NXM_NX_TUN_IPV4_DST[],load:${nsp}->NXM_NX_TUN_ID[0..31],resubmit(${output_port},0)"

ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=80 actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],push_nsh,load:0x1->NXM_NX_NSH_MDTYPE[],load:0x3->NXM_NX_NSH_NP[],load:$ip->NXM_NX_NSH_C1[],load:$nsp->NXM_NX_NSP[0..23],load:0xff->NXM_NX_NSI[],load:$ip->NXM_NX_TUN_IPV4_DST[],load:0x126->NXM_NX_TUN_ID[0..31],resubmit(,0)"
ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=22 actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],push_nsh,load:0x1->NXM_NX_NSH_MDTYPE[],load:0x3->NXM_NX_NSH_NP[],load:$ip->NXM_NX_NSH_C1[],load:$nsp->NXM_NX_NSP[0..23],load:0xff->NXM_NX_NSI[],load:$ip->NXM_NX_TUN_IPV4_DST[],load:0x126->NXM_NX_TUN_ID[0..31],resubmit(,0)"


ovs-ofctl -O Openflow13 del-flows br-int "table=158,nsi=255,nsp=294"
ovs-ofctl -O Openflow13 add-flow br-int "table=158, n_packets=10, priority=651,nsi=255,nsp=294 actions=move:NXM_NX_NSH_MDTYPE[]->NXM_NX_NSH_MDTYPE[],move:NXM_NX_NSH_NP[]->NXM_NX_NSH_NP[],move:NXM_NX_NSH_C1[]->NXM_NX_NSH_C1[],move:NXM_NX_NSH_C2[]->NXM_NX_NSH_C2[],move:NXM_NX_TUN_ID[0..31]->NXM_NX_TUN_ID[0..31],load:0x3->NXM_NX_TUN_GPE_NP[],output:6"
