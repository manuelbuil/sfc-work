tacker sfc-classifier-delete yellow_farbe
tacker sfc-classifier-create --name red_http --chain red --match source_port=0,dest_port=80,protocol=6
tacker sfc-classifier-create --name red_ssh --chain red --match source_port=0,dest_port=22,protocol=6
compute_ip=10.20.0.11
nsp_red=0x96
ssh ${compute_ip} 'bash sfc-work/seattle/correct_classifier.bash ${nsp_red}'
