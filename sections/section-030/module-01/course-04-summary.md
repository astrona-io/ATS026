---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Summary

A Service is a stable virtual address with a type, a selector and a list of ports. The type decides how far the address reaches. ClusterIP is reachable inside the cluster only. NodePort adds a port on every node. LoadBalancer adds a request for an external load balancer on top of a NodePort. No type starts an application or repairs a broken backend.

The selector decides which Pods are backends. The EndpointSlice controller watches Pods, matches their labels against the selector, and writes the matching Pod addresses into EndpointSlice objects. Each address has a `ready` condition that comes from the Pod readiness probe. `kube-proxy` on each node reads the EndpointSlices and writes the forwarding rules. A selector that matches no Pod gives an empty EndpointSlice and no error.

Ports have two sides. The Service `port` is what clients connect to. The `targetPort` is the port on the Pod, given as a number or as the name of a container port. The container process must really listen on that port. A wrong `targetPort` gives a refused connection, a selector with no match gives a timeout or no backend, and a failed readiness probe removes the Pod from the ready addresses.

External access needs more than the Service object. A NodePort needs reachable node addresses and an open firewall. A LoadBalancer needs a controller in the cluster that provisions the load balancer, so on a cluster without one the external address stays `<pending>`. Web routing with host names and paths needs a controller that implements Ingress or the Gateway API.

Key facts to remember:

- Check a Service in this order: selector and Pod labels, EndpointSlice addresses and conditions, `targetPort` and the container listener.
- The default NodePort range is 30000 to 32767.
- Direct access to a Pod IP does not prove that the Service selects the Pod.
- A `Running` Pod that is not `Ready` receives no Service traffic.

<!-- astrona:playground:destroy -->
