client_port=$1
output_port=$2
block_port=$3
nsp=$4
tun_id=$5
mac_tap_interface=$6
mac_SF_interface=$7


ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=80"
ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=22"
ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=$(block_port),in_port=${client_port} actions=load:${tun_id}->NXM_NX_TUN_ID[],push_nsh,load:0x1->NXM_NX_NSH_MDTYPE[],load:0x3->NXM_NX_NSH_NP[],load:${nsp}->NXM_NX_NSP[0..23],load:0xff->NXM_NX_NSI[],load:0x1->NXM_NX_NSH_C1[],load:${tun_id}->NXM_NX_NSH_C2[],load:0x3->NXM_NX_NSH_C3[],load:0x4->NXM_NX_NSH_C4[],goto_table:152" 

ovs-ofctl -O Openflow13 del-flows br-int "table=152,nsi=255"
ovs-ofctl -O Openflow13 add-flow br-int "table=152, priority=550,nsi=255,nsp=${nsp} actions=load:${mac_tap_interface}->NXM_NX_ENCAP_ETH_SRC[],load:${mac_SF_interface}->NXM_NX_ENCAP_ETH_DST[],goto_table:158"

ovs-ofctl -O Openflow13 del-flows br-int "table=158,nsi=255"
ovs-ofctl -O Openflow13 del-flows br-int "table=158,nsi=254"
ovs-ofctl -O Openflow13 add-flow br-int "table=158, priority=550,nsi=255,nsp=${nsp} actions=output:${tap_SF}"

ovs-ofctl -O Openflow13 del-flows br-int "table=0,udp"
ovs-ofctl -O Openflow13 del-flows br-int "table=0,nsp=${nsp}"
ovs-ofctl -O Openflow13 add-flow br-int "table=0, encap_eth_type=0x894f actions=goto_table:152"

ovs-ofctl -O Openflow13 add-flow br-int “table=158, nsi=254, nsp=${nsp} actions=pop_nsh,resubmit(,0)”
