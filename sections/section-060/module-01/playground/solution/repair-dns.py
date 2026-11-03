import json,subprocess
assert subprocess.check_output(['kubectl','config','current-context'],text=True).strip()=='kind-astro-ats-026-playground-060-01'
baseline=json.loads(subprocess.check_output(['kubectl','-n','starfleet','get','configmap','dns-baseline','-o','json'],text=True))['data']['Corefile']
subprocess.run(['kubectl','-n','kube-system','patch','configmap','coredns','--type=merge','-p',json.dumps({'data':{'Corefile':baseline}})],check=True)
subprocess.run(['kubectl','-n','kube-system','rollout','restart','deployment/coredns'],check=True)
