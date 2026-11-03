---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Summary

The Gateway API splits ingress configuration into three resource kinds. A `GatewayClass` names the controller. A `Gateway` asks that controller for an entry point and declares listeners, each with a protocol, a port, an optional host name and an `allowedRoutes` rule. An `HTTPRoute` names its Gateway in `parentRefs`, lists host names, rules and matches, and names its backends in `backendRefs`. The Kubernetes API server only stores these objects. The controller reads them, builds the data plane and writes the result into the status.

A route is active only when two checks pass. The listener must allow the route's namespace and kind, which the controller reports as the `Accepted` condition, and every backend reference must point to an existing Service and a Service port, which the controller reports as `ResolvedRefs`. A refused attachment shows `Accepted=False` with the reason `NotAllowedByListeners`. A missing Service shows `ResolvedRefs=False` with the reason `BackendNotFound`. The `attachedRoutes` count of a listener shows how many routes attached.

A request is matched by its `Host` header against the route `hostnames` and then by the rule matches. A request that matches no route gets an HTTP 404 answer from the proxy, and a timeout means the request did not reach the proxy at all. A successful `kubectl apply` says nothing about traffic; the status conditions and a request through the Gateway address are the evidence.

Key facts to remember:

- `GatewayClass` is cluster-scoped; `Gateway` and `HTTPRoute` are namespaced.
- `allowedRoutes.namespaces.from` is `Same` by default, and also accepts `All` and `Selector`.
- The backend port in `backendRefs` is the Service port, not the container port.
- `Programmed` is a Gateway condition; `Accepted` and `ResolvedRefs` are route conditions per parent.

<!-- astrona:playground:destroy -->
