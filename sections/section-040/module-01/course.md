---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Gateway Classes, Listeners And Routes

A Kubernetes cluster does not accept outside HTTP traffic by itself. Something must open a port, decide which request goes to which Service, and report whether that worked. The Gateway API is the set of Kubernetes resource types that describe this, and it splits the work among three kinds of object: a `GatewayClass`, a `Gateway` and an `HTTPRoute`. This module teaches what each object does, which component reads it, and how to tell from the status fields whether traffic can flow.

Keep one sentence in mind: **a route is active only when a listener allows it to attach and the controller accepts the match and the backend.** You will list the installed classes, create a Gateway and a route, read their status conditions, and then make a route fail on purpose to see which condition reports it.

The module has two parts. The first part explains the three resource kinds, the controller and the fields that connect them. The second part creates a Gateway and an HTTPRoute, sends requests through them and reads the conditions the controller writes.

## Learning objectives

After this module you can:

- Name the job of a `GatewayClass`, a `Gateway` and an `HTTPRoute`, and the component that reads each one.
- Write a `Gateway` with an HTTP listener and an `allowedRoutes` rule for the namespaces that may attach.
- Write an `HTTPRoute` with `parentRefs`, `hostnames`, a path match and a `backendRefs` entry.
- Read the `Accepted`, `ResolvedRefs` and `Programmed` conditions and say which one fails for which cause.
- Send a request through the Gateway address with a `Host` header and explain why a request for another host gets no route.

## Before you start

You need to know Pods, Deployments, Services and namespaces, and the commands `kubectl get`, `kubectl apply` and `kubectl describe`.

The playground is a kind cluster with Kubernetes 1.35, the Gateway API custom resource definitions and the Envoy Gateway controller already installed. It has a `GatewayClass` named `eg` and these workloads:

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | `edge` Gateway | A Gateway of class `eg` with one HTTP listener on port 80 that allows routes from its own namespace |
| `starfleet` | `probe` Deployment and Service | Two replicas of a small HTTP server that answers with `version=v1` |
| `starfleet` | `shuttle` Pod | A client Pod with `wget`, used to send requests from inside the cluster |
| `outpost` | `drifter` Pod | A client Pod in another namespace |

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
