report=get('configmap','dns-review')['data']
assert report['resolvedAddress']==get('service','probe')['spec']['clusterIP'], 'Record the current Service address'
