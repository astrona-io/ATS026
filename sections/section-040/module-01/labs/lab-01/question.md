---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Attach An HTTPRoute To A Gateway

Connect class, listener, route and backend and inspect controller acceptance.

## Starting state

The isolated environment has two healthy probe replicas, an internal Service and two client Pods. The required result has not been configured.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-026-lab-040-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-026-lab-040-01-01" || exit 1
node_name="astro-ats-026-lab-040-01-01-control-plane"
worker_name="astro-ats-026-lab-040-01-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Create Gateway probe using class eg and an HTTP listener on port 80 allowing same-namespace routes. Attach HTTPRoute probe for host probe.local, Prefix path / and backend probe port 80. Gateway Programmed and route Accepted and ResolvedRefs conditions must be True. A request through the generated Envoy Service must receive version one with the matching Host header.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
