---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Diagnose Pod-To-Pod Connectivity

A request from one Pod to another can fail for at least six different reasons, and every reason looks like "the connection does not work" at first. This module gives you a fixed order of checks and the tools to run them, so that each failure ends in one named cause: the address, the listener, the Service, the route between nodes, a network policy or name resolution.

Keep one rule in mind: **change nothing until you know which layer failed.** You will read what a timeout, a refusal and a reset each say about the failure, start a debug container next to a running Pod, and repair a workload whose server cannot be reached.

The module has two parts. The first part defines the order of checks and the tools that run them. The second part walks through the common causes one by one and shows how each one appears to the client.

## Learning objectives

After this module you can:

- Name the layers a Pod-to-Pod request passes through and test each layer separately.
- Tell a timeout, a refused connection and a reset apart and name the likely cause of each.
- Start an ephemeral debug container in a running Pod with `kubectl debug`.
- Find a server that listens only on the loopback address and a Service whose `targetPort` does not match the container.
- Read EndpointSlices to see which Pods a Service selects.

## Before you start

You need to know Pods, Deployments, Services, namespaces and the commands `kubectl get`, `kubectl apply` and `kubectl exec`.

The playground is a kind cluster with one control plane node and one worker node, running Kubernetes 1.35. It has the example workloads and three workloads that are broken on purpose:

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | `scout`, `probe`, `bridge`, `shuttle` | The healthy example application and a client Pod with `curl` |
| `outpost` | `probe`, `drifter` | A second backend and a client that belongs to another team |
| `starfleet` | `relay` | A web server that listens only on `127.0.0.1`, behind a Service named `relay` |
| `starfleet` | `beacon` | A web server behind a Service whose `targetPort` is wrong |
| `starfleet` | `hold` | A Deployment whose readiness probe always fails |

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
