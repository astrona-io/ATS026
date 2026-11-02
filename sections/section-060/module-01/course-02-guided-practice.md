---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Guided Practice: Restore A Broken CoreDNS Configuration

Use a host shell with the private kubeconfig for this module playground. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-026-playground-060-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-026-playground-060-01" || exit 1
node_name="astro-ats-026-playground-060-01-control-plane"
worker_name="astro-ats-026-playground-060-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Inspect And Explain

Bootstrap saves the original Corefile, introduces an invalid directive and restarts CoreDNS. The application listeners remain healthy while name resolution fails.

Inspect the current objects before changing them:

```sh
kubectl -n starfleet get pods -o wide
kubectl get nodes -o wide
```

Restore CoreDNS Corefile exactly to the saved dns-baseline value, restart its Deployment and record ConfigMap dns-repair with result restored. Name lookup and the original client request must succeed. Preserve the saved baseline and all other DNS data. Do not replace Service names with fixed Pod addresses.

Save this as `configmap-dns-repair.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: dns-repair
  namespace: starfleet
data:
  result: restored
```

Save this as `repair-dns.py`:

```python
import json,subprocess
assert subprocess.check_output(['kubectl','config','current-context'],text=True).strip()=='kind-astro-ats-026-playground-060-01'
baseline=json.loads(subprocess.check_output(['kubectl','-n','starfleet','get','configmap','dns-baseline','-o','json'],text=True))['data']['Corefile']
subprocess.run(['kubectl','-n','kube-system','patch','configmap','coredns','--type=merge','-p',json.dumps({'data':{'Corefile':baseline}})],check=True)
subprocess.run(['kubectl','-n','kube-system','rollout','restart','deployment/coredns'],check=True)
```

Apply the scoped correction:

```sh
python3 repair-dns.py
kubectl apply -f configmap-dns-repair.yaml
```

## Verify The Result

Observe the actual result. A denied request returns a nonzero status when the denial works, so run it separately from a shell sequence that stops on error. Status convergence and a successful request establish different parts of the result.

```sh
kubectl -n kube-system rollout status deployment/coredns --timeout=240s
kubectl -n starfleet exec shuttle -- nslookup probe.starfleet.svc.cluster.local
kubectl -n starfleet exec shuttle -- wget -q -T 3 -O- http://probe/
```

Trace failed name resolution to a Corefile syntax error and restore the saved configuration. The commands above deliberately target one environment. Keep its remaining components available so an unrelated failure cannot stand in for the required denial or correction. No example command output is presented as evidence of a completed run. A matching field alone does not establish that a process used it or that a controller reconciled it.


## Common pitfalls

> [!WARNING]
> Confirm the private context and exact node names before a change. Check the stated scope and live result. Do not change unrelated components to hide the original fault.
