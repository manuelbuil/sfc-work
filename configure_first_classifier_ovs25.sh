output_port=6
nsp=0x32
ip=0xc0a8002b
nsp_dec=$(($nsp))

echo $nsp
echo $ip
echo $nsp_dec


ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=80"
ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=22"

ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=80 actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],push_nsh,load:0x1->NXM_NX_NSH_MDTYPE[],load:0x3->NXM_NX_NSH_NP[],load:$ip->NXM_NX_NSH_C1[],load:$nsp->NXM_NX_NSP[0..23],load:0xff->NXM_NX_NSI[],load:$ip->NXM_NX_TUN_IPV4_DST[],load:$nsp->NXM_NX_TUN_ID[0..31],resubmit($output_port,0)"
ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=22 actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],push_nsh,load:0x1->NXM_NX_NSH_MDTYPE[],load:0x3->NXM_NX_NSH_NP[],load:$ip->NXM_NX_NSH_C1[],load:$nsp->NXM_NX_NSP[0..23],load:0xff->NXM_NX_NSI[],load:$ip->NXM_NX_TUN_IPV4_DST[],load:$nsp->NXM_NX_TUN_ID[0..31],resubmit($output_port,0)"


ovs-ofctl -O Openflow13 del-flows br-int "table=158,nsi=255,nsp=$nsp_dec"
ovs-ofctl -O Openflow13 add-flow br-int "table=158, priority=651,nsi=255,nsp=$nsp_dec actions=move:NXM_NX_NSH_MDTYPE[]->NXM_NX_NSH_MDTYPE[],move:NXM_NX_NSH_NP[]->NXM_NX_NSH_NP[],move:NXM_NX_NSH_C1[]->NXM_NX_NSH_C1[],move:NXM_NX_NSH_C2[]->NXM_NX_NSH_C2[],move:NXM_NX_TUN_ID[0..31]->NXM_NX_TUN_ID[0..31],load:0x3->NXM_NX_TUN_GPE_NP[],output:$output_port"
