tacker sfc-classifier-delete blue_ssh
tacker sfc-classifier-delete blue_http 
tacker sfc-classifier-create --name yellow_http --chain yellow --match source_port=0,dest_port=80,protocol=6

compute_ip=10.20.0.11
ssh ${compute_ip} 'bash sfc-work/seattle/correct_flows_symmetric.sh'
