---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Summary

A Service changes two things in the cluster: what the cluster DNS server answers for its name, and what the forwarding rules on each node do with packets sent to it. A normal ClusterIP Service gets one virtual address, and DNS answers with that address. A headless Service has `clusterIP: None`, gets no virtual address and no forwarding rules, and DNS answers with the addresses of the ready Pods. The client then chooses among them.

An ExternalName Service has no selector and no address. DNS answers with a CNAME record that points to another DNS name, and the client resolves that name and connects to it directly. Nothing in the cluster proxies the connection, so the port is not translated and a mismatch of host names can matter for HTTP and TLS. A Service without a selector gets no EndpointSlice from the controller. An administrator writes the EndpointSlice, with the label `kubernetes.io/service-name`, to point the Service at fixed addresses.

Session affinity `ClientIP` makes `kube-proxy` send all new connections from one client source address to the same backend for `timeoutSeconds`, which is 10800 seconds by default. It identifies a client only by the source address, so many clients behind one address share one backend. `externalTrafficPolicy: Local` keeps the client source address and sends external traffic only to backends on the receiving node. `internalTrafficPolicy: Local` limits traffic from Pods to backends on the same node.

`kube-proxy` writes the forwarding rules in one of several modes: `iptables`, `ipvs` or `nftables` on Linux. The mode is set in the `kube-proxy` configuration, and the Service behaviour that clients see stays the same.

Key facts to remember:

- A headless Service returns Pod addresses in DNS and has no ClusterIP.
- An ExternalName Service returns a CNAME and does not forward traffic.
- Session affinity is per client source address and expires after the timeout.
- With `externalTrafficPolicy: Local`, a node with no local backend drops the connection.

<!-- astrona:playground:destroy -->
