---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# CoreDNS Capstone: Headless Records, Rewrite, Own Resolver And Scale

The fleet applications in the `starfleet` namespace have four DNS problems. The `crew` StatefulSet must be reachable by Pod name, an old client calls a name that no Service has, the `auditor` Deployment must use only the partner DNS server, and the cluster DNS needs more capacity. The `shuttle` Deployment is a client with `nslookup` and `wget`, and the Service `partner-dns` answers the zone `partner.example` with `relic.partner.example` at `192.0.2.10`.

## Tasks

1. The StatefulSet `crew` has two Pods and the governing Service `crew`. The names `crew-0.crew.starfleet.svc.cluster.local` and `crew-1.crew.starfleet.svc.cluster.local` must resolve to the Pod IPs. The Service must keep port 80.
2. The name `deck.fleet.internal` must resolve to the ClusterIP of the Service `bridge`, with a rewrite rule in the CoreDNS Corefile.
3. The Deployment `auditor` must use only the DNS server behind the Service `partner-dns`, with the DNS option `ndots` set to 1. From `auditor`, the name `relic.partner.example.` must resolve.
4. The `coredns` Deployment in `kube-system` must run three ready replicas.

## Constraints

- Keep the existing `.:53` server block of the Corefile, including the `kubernetes` and `forward` directives.
- Do not delete the `crew` StatefulSet, the `partner-dns` Deployment or the `bridge` Service.
- CoreDNS must run the new configuration before you submit.

Check your work with `astrona submit -c .`.
