---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Summary

Every Pod has one IP address, assigned by the CNI plugin when the Pod starts. All containers of the Pod share that address and its port space, and they reach each other through the loopback address. The address is released when the Pod is deleted, so it must never be stored as configuration.

Kubernetes requires that all Pods can reach all Pods across nodes and namespaces without address translation. The network plugin decides how: by routing between nodes or by wrapping packets for transport. A namespace is a naming scope, not a network boundary.

Name resolution happens before the connection. The kubelet writes the resolver file of each Pod with the address of the cluster DNS Service, a search list that starts with the namespace of the Pod, and `ndots:5`. A short name is expanded with each suffix in order, so the same name can reach a different Service from a different namespace.

A failure has two phases. Exit code 6 from curl means the name did not resolve. Exit codes 7 and 28 mean the name resolved and the connection was refused or timed out. Testing by Pod IP removes the name from the problem, and testing by name checks the DNS path.

Key facts to remember:

- The ClusterIP of a Service is virtual and is implemented by forwarding rules, not by an interface.
- `service.namespace` works from every namespace; a bare `service` works only from its own.
- A resolving name does not prove that the Service has ready Pods.
- NetworkPolicy enforcement depends on the plugin, not on CNI itself.

<!-- astrona:playground:destroy -->
