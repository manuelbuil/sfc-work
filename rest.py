#!/usr/bin/env python

import requests

#To do HTTP Requests
def request(method,auth,headers,url,data):
    r = requests,request(method, url=url, headers=headers, data=data, auth=auth)

#Uses the ODL Rest API to configure the coexistence
def coexistence:
    headers = {'Content-Type': 'application/json'}
    data = {"netvirt-providers-config": {'table-offset':'0'}}
    data=json.dumps(data)
    auth = ('admin','admin')
    url = 'http://'${mgmt_addr}':8181/restconf/config/netvirt-providers-config:netvirt-providers-config'
    r = httpRequest(PUT,auth,headers,url,data)

    data2 = {"sfc-of-renderer-config":{"sfc-of-table-offset":"150","sfc-of-app-egress-table-offset":"11"}}
    data2 = json.dumps(data2)
    url = 'http://'${mgmt_addr}':8181/restconf/config/sfc-of-renderer:sfc-of-renderer-config'
    r = httpRequest(PUT,auth,headers,url,data)

