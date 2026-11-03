---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Use the Gateway API to manage Ingress traffic

An HTTPRoute exists, but the Gateway listener does not allow its namespace to attach. Another route points at a Service in a different namespace, and the proxy returns an HTTP 500 response because no ReferenceGrant allows the reference. Resource creation succeeded in both cases, and the status conditions of the route show why traffic does not flow.

This section has two modules. The first module explains the three resource kinds (`GatewayClass`, `Gateway` and `HTTPRoute`), the controller that reads them, and the `Accepted`, `ResolvedRefs` and `Programmed` conditions. The second module covers path and header matches, match precedence, weighted backends, the redirect, rewrite and header filters, and the two permission checks that apply when a route or a Service is in another namespace.

Each module has a playground, a private cluster with the Gateway API and the Envoy Gateway controller where you can try every command. Each module ends with a graded lab and a summary. A capstone lab combines the skills: it starts with three faulty routes on one Gateway, and you read their conditions and repair them without widening access. A knowledge check closes the section.

## Learning Outcomes

- Distinguish the roles of the `GatewayClass`, the `Gateway` listener and the `HTTPRoute`.
- Evaluate namespace attachment with `allowedRoutes` and hostname relationships.
- Choose the rule that serves a request from path and header matches, and split traffic with weights.
- Redirect, rewrite and change requests with `RequestRedirect`, `URLRewrite` and `RequestHeaderModifier`.
- Explain backend references and the `ReferenceGrant` permission across namespaces.
- Interpret the acceptance, programming and reference conditions and their reasons.
