---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Trace DNS To A Service Address

Compare a resolved Service name with the actual ClusterIP and repeat the application request.

## Starting state

The isolated environment has two healthy probe replicas, an internal Service and two client Pods. The required result has not been configured.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-026-lab-010-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-026-lab-010-01-01" || exit 1
node_name="astro-ats-026-lab-010-01-01-control-plane"
worker_name="astro-ats-026-lab-010-01-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Create ConfigMap dns-review with service probe, namespace starfleet and resolvedAddress matching the probe Service ClusterIP. Obtain the resolved address from a real DNS lookup inside shuttle. Preserve both healthy application replicas and verify the original Service request.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
