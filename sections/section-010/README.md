---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Understand connectivity between Pods

A Pod IP changes when the application is replaced, but a Service still provides the same access point. Pod addressing and Service forwarding are different network responsibilities. Knowing both lets you place a request failure in one named layer: the name, the address, the listener, the Service, a policy or the route between nodes.

This section has two modules and a capstone. The first module explains where Pod addresses come from, which component carries traffic between nodes and how a Service name becomes an address. The second module gives a fixed order of checks and the tools that run them, then walks through the common causes of a failed request and shows how each one looks at the client. Each module has its own playground for free practice and a graded lab. The capstone is a graded lab in which three workloads in one cluster are unreachable for three different reasons. A knowledge check of 12 questions closes the section.

## Learning Outcomes

- Explain Pod address and shared-network behavior.
- Identify network implementation responsibilities.
- Distinguish name resolution from destination connectivity.
- Diagnose listener, address, port and selector faults with ordered checks.
- Use `kubectl debug` and EndpointSlices to prove a cause before changing anything.
