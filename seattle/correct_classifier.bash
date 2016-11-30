ip_compute=0xc0a80009

ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=22"
ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=80"
ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=22 actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],push_nsh,load:0x1->NXM_NX_NSH_MDTYPE[],load:0x3->NXM_NX_NSH_NP[],load:$ip_compute->NXM_NX_NSH_C1[],load:${1}->NXM_NX_NSP[0..23],load:0xff->NXM_NX_NSI[],load:0xc0a8002b->NXM_NX_TUN_IPV4_DST[],load:${1}->NXM_NX_TUN_ID[0..31],resubmit(8,0)"
ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=80 actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],push_nsh,load:0x1->NXM_NX_NSH_MDTYPE[],load:0x3->NXM_NX_NSH_NP[],load:$ip_compute->NXM_NX_NSH_C1[],load:${1}->NXM_NX_NSP[0..23],load:0xff->NXM_NX_NSI[],load:0xc0a8002b->NXM_NX_TUN_IPV4_DST[],load:${1}->NXM_NX_TUN_ID[0..31],resubmit(8,0)"
