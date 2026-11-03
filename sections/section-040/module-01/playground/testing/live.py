gateway=get('gateway','probe')
assert any(c['type']=='Programmed' and c['status']=='True' for c in gateway['status']['conditions']), 'Program the actual gateway'
route=get('httproute','probe')
assert any(all(any(c['type']==required and c['status']=='True' for c in parent.get('conditions',[])) for required in ('Accepted','ResolvedRefs')) for parent in route.get('status',{}).get('parents',[])), 'Accept and resolve the attached route'
services=json.loads(kubectl('-n','envoy-gateway-system','get','services','-l','gateway.envoyproxy.io/owning-gateway-name=probe,gateway.envoyproxy.io/owning-gateway-namespace=starfleet','-o','json'))['items']
assert len(services)==1, 'Find the controller-managed gateway Service'
address=services[0]['spec']['clusterIP']
script="import urllib.request; request=urllib.request.Request('http://"+address+"/',headers={'Host':'probe.local'}); print(urllib.request.urlopen(request,timeout=5).read().decode())"
assert 'version=v1' in kubectl('-n','starfleet','exec','deployment/probe','--','python','-c',script), 'Verify traffic through the actual gateway'
