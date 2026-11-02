import json,subprocess,tempfile
from pathlib import Path
assert subprocess.check_output(['kubectl','config','current-context'],text=True).strip()=='kind-astro-ats-026-lab-060-01-01'
current=json.loads(subprocess.check_output(['kubectl','-n','kube-system','get','configmap','coredns','-o','json'],text=True))
baseline={'apiVersion':'v1','kind':'ConfigMap','metadata':{'name':'dns-baseline','namespace':'starfleet'},'data':{'Corefile':current['data']['Corefile']}}
with tempfile.TemporaryDirectory(prefix='training-dns-') as temporary:
    source=Path(temporary)/'configmap-baseline.json';source.write_text(json.dumps(baseline));subprocess.run(['kubectl','apply','-f',str(source)],check=True)
current['data']['Corefile']+='\ninvalid_training_directive\n'
subprocess.run(['kubectl','-n','kube-system','patch','configmap','coredns','--type=merge','-p',json.dumps({'data':current['data']})],check=True)
subprocess.run(['kubectl','-n','kube-system','rollout','restart','deployment/coredns'],check=True)
