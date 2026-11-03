---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Summary

A Pod accepts all traffic until a NetworkPolicy selects it. Once a policy selects a Pod for a direction, only the traffic that the rules of all selecting policies allow passes in that direction. Policies cannot deny; they can only add allowed connections to the isolation that selection creates.

`spec.podSelector` chooses the protected Pods, `spec.policyTypes` chooses the direction, and each rule lists peers and ports. A peer is a Pod selector, a namespace selector or an IP block. Selectors inside one entry must all match, and separate entries are alternatives, so one missing dash changes the policy.

Egress rules use `to` and must name every destination the client needs. DNS is such a destination: the rule must allow UDP and TCP port 53 to the CoreDNS Pods, selected by namespace and Pod label. Replies to allowed connections need no rule.

Enforcement belongs to the network plugin. The API server accepts a policy whatever the plugin does. A policy that has no effect on a cluster without enforcement gives no error, so a request that should be dropped is the only reliable test. A dropped packet looks like a timeout to the client.

Key facts to remember:

- An empty `podSelector` selects every Pod in the namespace of the policy.
- `kubernetes.io/metadata.name` labels every namespace with its own name.
- Use `ipBlock` only for addresses outside the cluster.
- Both the egress policy of the client and the ingress policy of the server must allow a connection.

<!-- astrona:playground:destroy -->
