---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Ingress Selection And Request Diagnosis

An Ingress is a Kubernetes object that declares how HTTP and HTTPS requests from outside the cluster reach Services inside it. The object only stores rules. An Ingress controller, a program that runs in the cluster, reads those rules and does the routing. This module teaches how the controller chooses a rule for a request and how to find the first step that fails when a request does not reach the application.

Keep one rule in mind: **a request passes several independent steps, and each step needs its own check.** The steps are name resolution, the connection to the controller, class selection, host and path matching, the Service port, the ready endpoints and the application.

## Learning objectives

After this module you can:

- Explain why an Ingress without a matching controller and IngressClass does nothing.
- Predict which rule a request matches from its host, its path and the path type.
- Map the Ingress backend port to the Service port and the Service `targetPort`.
- Explain what TLS termination at the controller does and does not protect.
- Tell a response from the controller apart from a response from the application.

## Before you start

You need to know Pods, Deployments, Services, namespaces and the commands `kubectl get`, `kubectl apply`, `kubectl describe` and `kubectl exec`.

The playground is a kind cluster that runs Kubernetes 1.35 and Traefik as the Ingress controller. Traefik runs in the `ingress-system` namespace behind a Service named `traefik` on port 80 (HTTP) and port 443 (HTTPS). The playground has these objects:

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | `probe` | Two Pods that answer on port 8080, behind a Service on port 80 |
| `starfleet` | `shuttle` | A client Pod with the BusyBox `wget` command |
| `outpost` | `drifter` | A client Pod that belongs to another team |
| `ingress-system` | `traefik` | The Ingress controller and the `traefik` IngressClass |

No Ingress exists at the start. You create the routes while you read.

## Reading order

The first part covers the controller contract, host and path matching, the backend port and TLS. The second part follows one request from the client to the application and shows how to attribute each failure to one step. A summary closes the module.

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
