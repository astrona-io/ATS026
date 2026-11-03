---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Overview: Choose A Controller, Class, Paths And Hosts (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, `astrona destroy`, start over.

## What's in the box

The Ingress controller Traefik runs in the `ingress-system` namespace behind the Service `traefik` on port 80 (HTTP) and port 443 (HTTPS). It handles the Ingresses of the IngressClass `traefik`. A second IngressClass, `legacy`, names a controller that is not installed. Neither class is the default at the start.

The `starfleet` namespace has four backends: `scout`, `probe`, `bridge` and `fallback`. Each one is an nginx server behind a Service on port 80. Each answers every path with its own name, the Host header it received and the path it received. The `shuttle` Deployment runs `curl` and sends the requests. No Ingress exists at the start.

## Helpers

Paste this into your shell. It sends one bounded request through the controller from the `shuttle` Pod. The first argument is the Host header and the second is the path.

```sh
through_traefik() { kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -H "Host: $1" "http://traefik.ingress-system.svc$2"; }
```

## Practice tasks

- List the IngressClasses with `kubectl get ingressclass` and read the `CONTROLLER` column.
- Mark the class `traefik` as the default class with the annotation `ingressclass.kubernetes.io/is-default-class` and create an Ingress without `ingressClassName`. Read the class that the API server stored.
- Create one Ingress with a `Prefix` path, an `Exact` path for the same prefix and a `defaultBackend`, and request paths with `through_traefik` to see which backend answers.
- Create an Ingress with the host `*.fleet.local` and request `a.fleet.local`, `a.b.fleet.local` and `fleet.local`.
- Read the controller log with `kubectl -n ingress-system logs deployment/traefik --tail=30` after each change.
