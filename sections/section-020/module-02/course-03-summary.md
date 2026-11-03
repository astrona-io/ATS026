---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Summary

A default-deny policy selects every Pod with an empty `podSelector` and lists a direction without rules, so it allows nothing in that direction. Allow policies are added next to it: one for traffic inside the namespace and narrow ones for each named peer. The allowed traffic of a Pod is the union of the rules of all policies that select it.

A peer from another namespace needs a `namespaceSelector`. When the namespace selector and the Pod selector are in one entry, both must match. Address ranges use `ipBlock` with optional `except` ranges and are meant for addresses outside the cluster. Port ranges use `port` with `endPort`.

A connection that times out and should work is investigated in a fixed order: the Service has ready endpoints, a policy selects the destination, the peer labels and namespace labels match, the rule names the Pod port, and the source has no egress policy that drops the connection. A label with no match selects nothing and gives no error.

A fix is verified from both sides: the client that must work and a client that must stay blocked. If every connection works, check whether the network plugin enforces policies at all.

Key facts to remember:

- Rules for ports use the container port of the Pod, not the Service port.
- A policy protects only Pods in its own namespace.
- A default-deny egress policy blocks DNS until a DNS rule is added.
- For a Pod that is already isolated, adding a policy can only open traffic; removing the last isolating policy opens everything.

<!-- astrona:playground:destroy -->
