---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Use ClusterIP, NodePort, LoadBalancer service types and endpoints

This section teaches how a Service gives a changing set of Pods one stable address, and how that address is reached from inside and from outside the cluster. It covers the three Service types, the selector and EndpointSlice objects that find the backends, the port mapping to the container, and the DNS answers for headless, ExternalName and selectorless Services.

Two modules carry the teaching. The first module explains Service types, selectors, ports, readiness and external entry, and ends with a fixed method for diagnosing a Service that has no working backend. The second module covers headless Services, ExternalName Services, session affinity, traffic policy and the `kube-proxy` modes. Each module has a playground for free practice and a graded lab, and the section ends with a capstone lab and a knowledge check.

## Learning Outcomes

After this section you can:

- Compare what ClusterIP, NodePort and LoadBalancer Services each add.
- Trace the Service port, the `targetPort` and the container listener.
- Read EndpointSlices and explain the ready condition of each address.
- Diagnose an empty selector match, a wrong target port and a failed readiness probe.
- Create headless, ExternalName and selectorless Services and explain their DNS answers.
- Configure session affinity and explain `externalTrafficPolicy`, `internalTrafficPolicy` and the `kube-proxy` modes.
