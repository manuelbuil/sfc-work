tacker sfc-classifier-delete blue_ssh
tacker sfc-classifier-delete blue_http 
tacker sfc-classifier-create --name purple_http --chain purple --match source_port=0,dest_port=80,protocol=6

compute_ip=10.20.0.7
ssh ${compute_ip} 'bash sfc-work/seattle/correct_flows_symmetric.sh'
