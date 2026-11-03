---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Summary

A request between two Pods passes through five layers: the name, the address, the route between nodes, the policy and the listener. Each layer can fail on its own, so a test at one layer proves nothing about the others. Testing from the Pod IP upward removes layers one at a time.

The way a connection ends names the layer. A timeout means the packet was dropped without an answer, which points to a policy, a route problem or an address that nobody owns. A refused connection means the destination answered that no process accepts the connection, which points to a wrong port or a server bound to another address. An HTTP status means the network path worked and an application answered.

The tools match the layers. `kubectl get pods -o wide` shows the Pod IP and the node. `kubectl get endpointslices` shows which ready Pods a Service selected. `kubectl debug` adds an ephemeral container that shares the network namespace of a running Pod, or copies a Pod with a different image or command. Events and logs explain probe failures and server start-up.

Four mistakes cause most failures. A server bound to `127.0.0.1` refuses every connection that arrives on the Pod IP. A Service `targetPort` that differs from the container port forwards traffic to a closed port. A failing readiness probe removes a Pod from the EndpointSlices. A selector that does not match the Pod labels leaves the Service without backends.

Key facts to remember:

- Test from a client Pod in the namespace that has the problem, never from your own machine.
- A refusal is never a NetworkPolicy drop; a drop is a timeout.
- `Running` does not mean `Ready`, and only ready Pods are in EndpointSlices.
- A named `targetPort` follows the container port name, so it survives a port number change.

<!-- astrona:playground:destroy -->
