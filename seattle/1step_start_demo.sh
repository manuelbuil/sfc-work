tacker sfc-classifier-delete purple_http
tacker sfc-classifier-create --name red_http --chain red --match source_port=0,dest_port=80,protocol=6
tacker sfc-classifier-create --name red_ssh --chain red --match source_port=0,dest_port=22,protocol=6
compute_ip=10.20.0.7
nsp_red=0x128
sleep 15
tacker sfc-classifier-list
ssh ${compute_ip} "bash /root/sfc-work/seattle/correct_classifier.bash ${nsp_red}"
