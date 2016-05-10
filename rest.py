#!/usr/bin/env python
import json
import requests

#To do HTTP Requests
def httpRequest(method,auth,headers,url,data):
    r = requests.request(method, url=url, headers=headers, data=data, auth=auth)
    return r

#Uses the ODL Rest API to configure the coexistence
def coexistence():
    headers = {'Content-Type': 'application/json'}
    data = {"netvirt-providers-config": {'table-offset':'2'}}
    data=json.dumps(data)
    auth = ('admin','admin')
    url = 'http://192.168.0.2:8181/restconf/config/netvirt-providers-config:netvirt-providers-config'
    r = httpRequest("PUT",auth,headers,url,data)
    r.raise_for_status()

    data2 = {"sfc-of-renderer-config":{"sfc-of-table-offset":"150","sfc-of-app-egress-table-offset":"11"}}
    data2 = json.dumps(data2)
    print(data2)
    url = 'http://192.168.0.2:8181/restconf/config/sfc-of-renderer:sfc-of-renderer-config'
    r = httpRequest("PUT",auth,headers,url,data2)
    r.raise_for_status()

if __name__ == '__main__':
    coexistence()
