---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Forward A Stub Domain And Tune Pod DNS

The partners of the fleet run their own DNS server for the zone `partner.example`. The cluster already contains a second DNS server behind the Service `partner-dns` in the `starfleet` namespace. The `shuttle` client in `starfleet` cannot resolve names in that zone yet.

## Tasks

1. Make `relic.partner.example.` resolve from the `shuttle` Pod to `192.0.2.10`. Send every query for the zone `partner.example` to the `partner-dns` Service. Use the ClusterIP of the Service, on port 53.
2. Keep cluster names working: `probe.starfleet.svc.cluster.local` must still resolve from `shuttle`.
3. Change the Deployment `shuttle` so that its Pods use the DNS option `ndots` with the value 2. The Pod must keep the default DNS policy and must still resolve the short name `probe`.

## Constraints

- Keep the existing `.:53` server block of the Corefile, including the `kubernetes` and `forward` directives.
- Do not change the `partner-dns` Deployment, Service or ConfigMap.
- Make sure that CoreDNS is running the new configuration before you submit.

Check your work with `astrona submit -c .`.
