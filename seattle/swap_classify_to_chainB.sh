tacker sfc-classifier-delete red_http
tacker sfc-classifier-delete red_ssh

tacker sfc-classifier-create --name blue_http --chain blue --match source_port=0,dest_port=80,protocol=6
tacker sfc-classifier-create --name blue_ssh  --chain blue --match source_port=0,dest_port=22,protocol=6
sleep 5 
tacker sfc-classifier-list

compute_ip=10.20.0.11
nsp_blue=0x96
ssh ${compute_ip} 'bash sfc-work/seattle/correct_classifier.bash ${nsp_blue}'

