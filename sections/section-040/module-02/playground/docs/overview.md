---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Overview: Route, Split And Rewrite Traffic With HTTPRoute (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, `astrona destroy`, start over.

## What's in the box

The cluster runs Kubernetes 1.35 with the Gateway API and the Envoy Gateway controller. The `GatewayClass` is named `eg`.

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Gateway `edge` | HTTP listener on port 80, routes from the same namespace only |
| `starfleet` | `scout-v1`, `scout-v2` | Services whose answer contains the message `v1` or `v2` |
| `starfleet` | `echo` | A Service that returns the request it received (path, headers) at `/anything` |
| `starfleet` | `shuttle` | A client Pod with `curl` |
| `catalog` | `stock` | A Service in a namespace that has no route |
| `outpost` | `drifter` | A Service in a second namespace |

## Helpers

Paste these into your shell. `GATEWAY` is the address of the Gateway, `via` sends one request from the `shuttle` Pod with the host name and path you choose, and `conditions` prints the status conditions of a route.

```sh
GATEWAY=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}')
via() { kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 5 -H "Host: $1" "http://$GATEWAY$2"; }
conditions() { kubectl -n "$1" get httproute "$2" -o jsonpath='{range .status.parents[*].conditions[*]}{.type}={.status} ({.reason}){"\n"}{end}'; }
```

## Practice tasks

- Write a route for `scout.local` with a default rule to `scout-v1` and a header rule to `scout-v2`, and send requests with and without the header.
- Write a route for `split.local` that sends 90 percent of requests to `scout-v1` and 10 percent to `scout-v2`, and count the answers of 40 requests.
- Add a `RequestRedirect` rule, a `URLRewrite` rule and a `RequestHeaderModifier` filter, and read the result at the `echo` backend.
- Create a route in `starfleet` that points to the Service `stock` in `catalog`, read the `ResolvedRefs` condition, then add a `ReferenceGrant` in `catalog`.
- Change the listener to `from: Selector`, label the namespace `outpost` and attach a route there.
