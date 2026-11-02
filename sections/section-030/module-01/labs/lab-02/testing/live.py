node=get('node','astro-ats-026-lab-030-01-02-control-plane',namespace='')
address=next(address['address'] for address in node['status']['addresses'] if address['type']=='InternalIP')
assert 'version=v1' in kubectl('-n','starfleet','exec','shuttle','--','wget','-q','-T','3','-O-','http://'+address+':30080/'), 'Verify actual NodePort forwarding'
