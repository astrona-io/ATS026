---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Attach An HTTPRoute To A Gateway

The `starfleet` namespace runs the `probe` Deployment with two replicas and the `probe` Service on port 80. The cluster has a `GatewayClass` named `eg`. Nothing exposes `probe` through a Gateway yet. The `shuttle` Pod in `starfleet` and the `drifter` Pod in `outpost` are client Pods.

## Tasks

1. Create a `Gateway` named `probe` in `starfleet` with the class `eg` and one listener named `http` with protocol `HTTP` and port `80`. The listener must allow routes from the same namespace only.
2. Create an `HTTPRoute` named `probe` in `starfleet` that attaches to the Gateway `probe`, for the host name `probe.local`, with a `PathPrefix` match on `/` and the backend Service `probe` on port `80`.
3. The Gateway must be `Programmed`, and the route must have the conditions `Accepted` and `ResolvedRefs` set to `True`.
4. A request with the header `Host: probe.local` sent through the Gateway address from the `shuttle` Pod must return the `probe` answer with `version=v1`.

## Constraints

- Do not change the `probe` Deployment or Service.
- Do not allow routes from other namespaces.

Check your work with `astrona submit -c .`.
