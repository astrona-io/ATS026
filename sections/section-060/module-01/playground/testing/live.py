assert get('configmap','coredns',namespace='kube-system')['data']['Corefile']==get('configmap','dns-baseline')['data']['Corefile'], 'Restore the exact scoped baseline'
