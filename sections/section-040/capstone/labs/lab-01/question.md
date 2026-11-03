---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Repair Gateway Routes Across Namespaces

The Gateway `edge` in the namespace `starfleet` has the class `eg` and one HTTP listener on port 80. The listener accepts routes only from namespaces that have the label `gateway-access=allowed`. Three teams own three routes on this Gateway. Each team reports a problem. The `shuttle` Pod in `starfleet` is a client with `curl`.

| Host name | Route | Backend | Report |
| --- | --- | --- | --- |
| `drifter.local` | `drifter` in `outpost` | Service `drifter` in `outpost` | Requests get no answer from the route |
| `stock.local` | `stock` in `starfleet` | Service `stock` in `catalog` | Requests return an HTTP 500 response |
| `scout.local` | `scout` in `starfleet` | `scout-v1`, `scout-v2` in `starfleet` | Too many requests reach the new version |

## Tasks

1. Find out why the route `drifter` is not accepted, and repair it so that `drifter.local` reaches the Service `drifter`.
2. Find out why the route `stock` has an unresolved backend, and repair it so that `stock.local` reaches the Service `stock`. The permission must cover only the Service `stock` and only HTTPRoute objects from `starfleet`.
3. Repair the route `scout` so that the default rule sends 90 percent of the traffic to `scout-v1` and 10 percent to `scout-v2` (weights 90 and 10). A request with the header `x-canary` and the exact value `true` must always go to `scout-v2`.

## Constraints

- Do not edit the Gateway `edge`. Its listener must keep a selector.
- Do not label the namespace `catalog`.
- Do not edit the Deployments or the Services.
- Do not delete a route.

Check your work with `astrona submit -c .`.
