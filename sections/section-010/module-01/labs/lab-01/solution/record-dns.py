import json,subprocess,tempfile
from pathlib import Path
assert subprocess.check_output(['kubectl','config','current-context'],text=True).strip()=='kind-astro-ats-026-lab-010-01-01'
address=json.loads(subprocess.check_output(['kubectl','-n','starfleet','get','service','probe','-o','json'],text=True))['spec']['clusterIP']
lookup=subprocess.check_output(['kubectl','-n','starfleet','exec','shuttle','--','nslookup','probe.starfleet.svc.cluster.local'],text=True)
assert address in lookup, 'The resolver must return the Service address'
report={'apiVersion':'v1','kind':'ConfigMap','metadata':{'name':'dns-review','namespace':'starfleet'},'data':{'service':'probe','namespace':'starfleet','resolvedAddress':address}}
with tempfile.TemporaryDirectory(prefix='training-dns-') as temporary:
    target=Path(temporary)/'configmap-dns.json';target.write_text(json.dumps(report));subprocess.run(['kubectl','apply','-f',str(target)],check=True)
