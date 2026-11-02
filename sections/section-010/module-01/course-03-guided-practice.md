---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Guided Practice: Trace DNS To A Service Address

Use a host shell with the private kubeconfig for this module playground. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-026-playground-010-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-026-playground-010-01" || exit 1
node_name="astro-ats-026-playground-010-01-control-plane"
worker_name="astro-ats-026-playground-010-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Inspect And Explain

The isolated environment has two healthy probe replicas, an internal Service and two client Pods. The required result has not been configured.

Inspect the current objects before changing them:

```sh
kubectl -n starfleet get pods -o wide
kubectl get nodes -o wide
```

Create ConfigMap dns-review with service probe, namespace starfleet and resolvedAddress matching the probe Service ClusterIP. Obtain the resolved address from a real DNS lookup inside shuttle. Preserve both healthy application replicas and verify the original Service request.

Save this as `configmap-dns-review.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: dns-review
  namespace: starfleet
data:
  service: probe
  namespace: starfleet
```

Save this as `record-dns.py`:

```python
import json,subprocess,tempfile
from pathlib import Path
assert subprocess.check_output(['kubectl','config','current-context'],text=True).strip()=='kind-astro-ats-026-playground-010-01'
address=json.loads(subprocess.check_output(['kubectl','-n','starfleet','get','service','probe','-o','json'],text=True))['spec']['clusterIP']
lookup=subprocess.check_output(['kubectl','-n','starfleet','exec','shuttle','--','nslookup','probe.starfleet.svc.cluster.local'],text=True)
assert address in lookup, 'The resolver must return the Service address'
report={'apiVersion':'v1','kind':'ConfigMap','metadata':{'name':'dns-review','namespace':'starfleet'},'data':{'service':'probe','namespace':'starfleet','resolvedAddress':address}}
with tempfile.TemporaryDirectory(prefix='training-dns-') as temporary:
    target=Path(temporary)/'configmap-dns.json';target.write_text(json.dumps(report));subprocess.run(['kubectl','apply','-f',str(target)],check=True)
```

Apply the scoped correction:

```sh
kubectl apply -f configmap-dns-review.yaml
python3 record-dns.py
```

## Verify The Result

Observe the actual result. A denied request returns a nonzero status when the denial works, so run it separately from a shell sequence that stops on error. Status convergence and a successful request establish different parts of the result.

```sh
kubectl -n starfleet exec shuttle -- nslookup probe.starfleet.svc.cluster.local
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe/
```

Compare a resolved Service name with the actual ClusterIP and repeat the application request. The commands above deliberately target one environment. Keep its remaining components available so an unrelated failure cannot stand in for the required denial or correction. No example command output is presented as evidence of a completed run. A matching field alone does not establish that a process used it or that a controller reconciled it.


## Common pitfalls

> [!WARNING]
> Confirm the private context and exact node names before a change. Check the stated scope and live result. Do not change unrelated components to hide the original fault.
