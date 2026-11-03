---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Summary

An Ingress stores routing rules and does nothing alone. An Ingress controller watches the Ingress objects through the Kubernetes API and configures its own proxy. The `ingressClassName` field names the IngressClass that selects which controller handles an Ingress, and a controller ignores an Ingress that names another class. The API server accepts such an Ingress without error, so acceptance does not prove that any traffic is routed.

The controller selects a rule from the request. A host rule compares the Host header with the `host` field. A path rule compares the request path with the `path` field and the path type: `Exact` compares the whole path, `Prefix` compares whole path elements split by `/`, and `ImplementationSpecific` leaves the decision to the controller. When several paths match, the longest path wins. Name resolution only finds the address of the controller. It does not choose the rule.

The backend of a rule names a Service and a Service port, not a container port. The Service maps its `port` to a `targetPort` on the selected ready Pods. The chain of Ingress, Service port, selector, ready endpoints and application listener has one failure point at a time, and a correct object at one step does not repair a fault at another.

TLS termination at the controller needs a Secret with a certificate and key that cover the requested host name. The client checks the certificate against the name it requested. The connection from the controller to the Service is plain HTTP unless the backend and the controller are configured otherwise. The controller also does not rewrite paths unless a controller-specific setting asks for it.

Diagnosis starts from the client observation. A name error points at DNS, a timeout points at the address or the network, a certificate error points at the TLS name or trust, a 404 or 503 with a controller body points at route or endpoint selection, and a response with application content points at the application.

Key facts to remember:

- An Ingress backend refers to a Service port, not to a container port.
- A request with the wrong Host header can match no rule even when the address is correct.
- A Service without ready endpoints gives no useful backend, whatever the Ingress says.
- Disabling certificate verification removes the property that the test must check.

<!-- astrona:playground:destroy -->
