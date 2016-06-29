printf -v nsp "0x%x" `ovs-ofctl -O Openflow13 dump-flows br-int table=11 | grep "nsp=" | awk '{print $6}' | awk -F ',' '{print $1}' | awk -F '=' '{print $2}'`
printf -v ip '0x%x' `ovs-ofctl -O Openflow13 dump-flows br-int table=158 | grep nshc1 | awk -F ',' '{print $9}' | awk -F '=' '{print $2}' | uniq`
#output_port=`ovs-ofctl -O Openflow13 dump-flows br-int table=11 | grep -v "nsp=" | awk -F ':' '{print $NF}'`
#client_port=`ovs-ofctl -O Openflow13 dump-flows br-int table=0 | grep in_port | awk -F ',' '{print $8}' | awk -F '=' '{print $NF}'`
client_port=$1
output_port=$2

ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=80"
ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=80,in_port=${client_port} actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],set_field:${ip}->nshc1,set_field:${nsp}->nsp,set_field:255->nsi,load:${ip}->NXM_NX_TUN_IPV4_DST[],load:${nsp}->NXM_NX_TUN_ID[0..31],resubmit(${output_port},0)"

ovs-ofctl -O Openflow13 del-flows br-int "table=11,tcp,reg0=0x1,tp_dst=22"
ovs-ofctl -O Openflow13 add-flow br-int "table=11,tcp,reg0=0x1,tp_dst=22,in_port=${client_port} actions=move:NXM_NX_TUN_ID[0..31]->NXM_NX_NSH_C2[],set_field:${ip}->nshc1,set_field:${nsp}->nsp,set_field:255->nsi,load:${ip}->NXM_NX_TUN_IPV4_DST[],load:${nsp}->NXM_NX_TUN_ID[0..31],resubmit(${output_port},0)"
