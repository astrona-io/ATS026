---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Choose A Controller, Class, Paths And Hosts

An Ingress does nothing until a controller handles it, and a cluster can run more than one controller. This module explains how an Ingress selects its controller through an IngressClass, what the default class does, and how a controller chooses a rule from the host and the path of a request. It also covers the rules that decide between several matching paths, the default backend and the limits of controller-specific settings.

Keep one rule in mind: **the standard Ingress fields say what to match, and only the controller decides what happens when the standard fields leave a choice open.** Class selection, the `ImplementationSpecific` path type, rewrites and the answer to an unmatched request all depend on the controller.

## Learning objectives

After this module you can:

- Read an IngressClass and name the controller that it selects.
- Make one IngressClass the default class and predict which Ingresses it affects.
- Write `Exact` and `Prefix` paths and predict which rule a request matches.
- Predict the rule that wins when several paths match.
- Use a wildcard host and a default backend and state what each one covers.
- Name the evidence that shows why an Ingress is not handled.

## Before you start

You need to know Pods, Deployments, Services and the fields `host`, `path` and `backend` of an Ingress.

The playground is a kind cluster that runs Kubernetes 1.35 and Traefik v3.6.1 as the Ingress controller. Traefik handles the IngressClass `traefik`. A second IngressClass, `legacy`, names a controller that is not installed. No class is the default at the start.

| Namespace | Object | What it is |
| --- | --- | --- |
| `ingress-system` | `traefik` | The controller and its Service on ports 80 and 443 |
| `starfleet` | `scout`, `probe`, `bridge`, `fallback` | Four backends. Each answers with its own name, the Host header and the path it received |
| `starfleet` | `shuttle` | A client Pod with `curl` |

## Reading order

The first part covers IngressClass, the default class and how to choose a controller. The second part covers hosts, path types, precedence, the default backend and controller-specific settings. A summary closes the module.

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
