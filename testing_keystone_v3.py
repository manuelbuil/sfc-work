import os
from keystoneclient import client
from keystoneauth1.identity import v3
from keystoneauth1 import session
from keystoneclient.v3 import client
from neutronclient.v2_0 import client as client_neutron
import json

auth_url = os.environ['OS_AUTH_URL']
auth_user = os.environ['OS_USERNAME']
auth_pass = os.environ['OS_PASSWORD']
auth_project = os.environ['OS_PROJECT_NAME']
auth_domain = os.environ['OS_USER_DOMAIN_NAME']
auth_project_domain = os.environ['OS_PROJECT_DOMAIN_NAME']
print(auth_url, auth_user, auth_pass, auth_project)


# you specified project_id and user_id
# but we have project_name and username
# also it needs the domain crap because it doesn't fall back to default
auth = v3.Password(auth_url=auth_url, username=auth_user, password=auth_pass, project_name=auth_project, user_domain_id='default', project_domain_id='default') #now?
sess = session.Session(auth=auth)
#keystone = client.Client(session=sess)
neutron = client_neutron.Client(session=sess)

netw = neutron.list_networks()
print dir(netw)
for net in netw['networks']:
    for k, v in net.items():
        print("%s : %s" % (k, v))
        print('\n')

#resp = sess.get('/v3/users', endpoint_filter={'service_type': 'identity', 'interface': 'public', 'region_name': 'myregion'})
