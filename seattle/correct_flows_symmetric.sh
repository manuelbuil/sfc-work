nsp_sym=8388966
vxlan_gpe=6
block_port=80
nsp=358

#ovs-ofctl -O Openflow13 add-flow br-int "table=1, priority=40000,nsi=254,nsp=$nsp_sym,reg0=0x1,in_port=$sf_port actions=pop_nsh,goto_table:21"
#ovs-ofctl -O Openflow13 add-flow br-int "table=11, n_packets=18, n_bytes=2115, nsi=254,nsp=$nsp_sym,in_port=8 actions=load:0x1->NXM_NX_REG0[],move:NXM_NX_NSH_C2[]->NXM_NX_TUN_ID[0..31],resubmit($sf_port,1)"

#ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=$block_port"

ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,tp_dst=80"
ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,tp_dst=22"

#ovs-ofctl -O Openflow13 add-flow br-int "table=11, tcp,reg0=0x1,tp_src=$block_port actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],push_nsh,load:0x1->NXM_NX_NSH_MDTYPE[],load:0x3->NXM_NX_NSH_NP[],load:0xc0a8002b->NXM_NX_NSH_C1[],load:$nsp_sym->NXM_NX_NSP[0..23],load:0xff->NXM_NX_NSI[],load:0xc0a8002b->NXM_NX_TUN_IPV4_DST[],load:$nsp_sym->NXM_NX_TUN_ID[0..31],resubmit($vxlan_gpe,0)"
ovs-ofctl -O Openflow13 add-flow br-int "table=11, tcp,reg0=0x1,tp_dst=$block_port actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],push_nsh,load:0x1->NXM_NX_NSH_MDTYPE[],load:0x3->NXM_NX_NSH_NP[],load:$nsp_sym->NXM_NX_NSH_C3[],load:0xc0a8002b->NXM_NX_NSH_C1[],load:$nsp->NXM_NX_NSP[0..23],load:0xff->NXM_NX_NSI[],load:0xc0a8002b->NXM_NX_TUN_IPV4_DST[],load:$nsp->NXM_NX_TUN_ID[0..31],resubmit($vxlan_gpe,0)"
#ovs-ofctl -O Openflow13 add-flow br-int "table=11, tcp,reg0=0x1,tp_dst=22 actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],push_nsh,load:0x1->NXM_NX_NSH_MDTYPE[],load:0x3->NXM_NX_NSH_NP[],load:$nsp_sym->NXM_NX_NSH_C3[],load:0xc0a8002b->NXM_NX_NSH_C1[],load:$nsp->NXM_NX_NSP[0..23],load:0xff->NXM_NX_NSI[],load:0xc0a8002b->NXM_NX_TUN_IPV4_DST[],load:$nsp->NXM_NX_TUN_ID[0..31],resubmit($vxlan_gpe,0)"
