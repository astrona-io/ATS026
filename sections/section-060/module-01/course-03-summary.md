---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Summary

A Pod does not resolve names itself. The kubelet writes `/etc/resolv.conf` into every Pod with the ClusterIP of the `kube-dns` Service as the name server, three search domains built from the Pod's namespace, and the option `ndots:5`. A short name such as `probe` is tried with each search domain in turn, so it becomes `probe.starfleet.svc.cluster.local` in the namespace of the Pod that asks. A name in another namespace needs at least the namespace, as in `probe.outpost`.

CoreDNS answers the queries. The `kube-dns` Service forwards them to the CoreDNS Pods, and the Corefile decides what each Pod does with a query. The `kubernetes` plugin answers names in the cluster domain from the Services and EndpointSlices it watches in the API server. The `forward` plugin sends every other name to the upstream resolvers. The `cache`, `loop`, `errors`, `health`, `ready` and `reload` plugins handle caching, loop detection, error logging, probes and live reload.

A Service name that resolves proves only that the Service object exists. It says nothing about ready backends. A failure that affects every Pod points at CoreDNS or at the path to it. A failure that affects one name points at the name, the namespace or the search domains. A failure of public names with working cluster names points at forwarding.

A Corefile with a syntax error stops the new CoreDNS Pods from starting. The Pods that already run keep serving from the old configuration, so the outage grows as Pods restart. The CoreDNS logs name the faulty line. The repair is to restore a valid Corefile in the `coredns` ConfigMap in `kube-system` and restart the Deployment with `kubectl rollout restart`.

Key facts to remember:

- The ConfigMap is `coredns` in `kube-system`, and the key is `Corefile`.
- The default cluster domain is `cluster.local`, and a cluster can change it.
- A lookup test and a connection test are separate checks.
- Verify one cluster name and one public name after every Corefile change.

<!-- astrona:playground:destroy -->
