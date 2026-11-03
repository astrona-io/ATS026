---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Matches, Weights, Filters And Cross-Namespace Routes

A single `HTTPRoute` with one path and one backend is only the start. Real traffic needs more: send a test group of requests to a new version, move 10 percent of requests to a second Service, redirect an old path, rewrite a path before it reaches an application, and let a route use a Service that lives in another namespace. The Gateway API has a field for each of these, and each field has rules about precedence and permission that decide what the controller does when two things conflict.

Keep one sentence in mind: **the controller picks one rule per request by match precedence, then applies that rule's filters and chooses a backend by weight, and it only allows a reference across a namespace border when the target namespace says yes.** You will build each behaviour, send requests through the Gateway, and read the status conditions that report a refused reference.

The module has three parts. The first part covers path and header matches, the order in which the controller picks a rule, and weighted backends. The second part covers the `RequestRedirect`, `URLRewrite` and `RequestHeaderModifier` filters. The third part covers routes in other namespaces: the `allowedRoutes` selector on a listener and the `ReferenceGrant` that lets a route reach a Service in another namespace.

## Learning objectives

After this module you can:

- Write path matches (`Exact`, `PathPrefix`) and header matches, and predict which rule wins when several match.
- Split traffic between two Services with `weight` and explain what a weight of 0 does.
- Redirect a request with `RequestRedirect` and change a request with `URLRewrite` and `RequestHeaderModifier`.
- Let routes from other namespaces attach to a Gateway with `allowedRoutes` and a namespace label selector.
- Allow a route to use a Service in another namespace with a `ReferenceGrant`, and read the `RefNotPermitted` reason when the grant is missing.

## Before you start

You need to know the three Gateway API resource kinds (`GatewayClass`, `Gateway`, `HTTPRoute`), a basic `HTTPRoute` with `parentRefs`, `hostnames` and `backendRefs`, and the `Accepted` and `ResolvedRefs` conditions.

The playground is a kind cluster with Kubernetes 1.35, the Gateway API custom resource definitions and the Envoy Gateway controller already installed. It has a `GatewayClass` named `eg` and these workloads:

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | `edge` Gateway | Class `eg`, one HTTP listener on port 80, routes from its own namespace only |
| `starfleet` | `scout-v1`, `scout-v2` | Services that answer with the message `v1` or `v2` |
| `starfleet` | `echo` | A Service that returns the request it received, at `/anything` |
| `starfleet` | `shuttle` | A client Deployment with `curl` |
| `catalog` | `stock` | A Service in a namespace that no route uses yet |
| `outpost` | `drifter` | A Service in another namespace |

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
