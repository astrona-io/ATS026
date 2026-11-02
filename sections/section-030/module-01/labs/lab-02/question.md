---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Reach A Service Through Its NodePort

Verify the client port, backend listener and allocated node entry port separately.

## Starting state

The isolated environment has two healthy probe replicas, an internal Service and two client Pods. The required result has not been configured.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-026-lab-030-01-02)"
test "$(kubectl config current-context)" = "kind-astro-ats-026-lab-030-01-02" || exit 1
node_name="astro-ats-026-lab-030-01-02-control-plane"
worker_name="astro-ats-026-lab-030-01-02-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Change probe to a NodePort Service with internal TCP port 80, targetPort http and nodePort 30080. Keep the existing selector and healthy replicas. A request from shuttle to this private cluster node address on port 30080 must receive version one. This does not publish a physical host port.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
