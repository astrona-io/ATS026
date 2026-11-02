---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Restore A Broken CoreDNS Configuration

Trace failed name resolution to a Corefile syntax error and restore the saved configuration.

## Starting state

Bootstrap saves the original Corefile, introduces an invalid directive and restarts CoreDNS. The application listeners remain healthy while name resolution fails.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-026-lab-060-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-026-lab-060-01-01" || exit 1
node_name="astro-ats-026-lab-060-01-01-control-plane"
worker_name="astro-ats-026-lab-060-01-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Restore CoreDNS Corefile exactly to the saved dns-baseline value, restart its Deployment and record ConfigMap dns-repair with result restored. Name lookup and the original client request must succeed. Preserve the saved baseline and all other DNS data. Do not replace Service names with fixed Pod addresses.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
