---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Overview: Customise And Debug CoreDNS (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, `astrona destroy`, start over.

## What's in the box

A kind cluster with one control plane node, one worker node and the default CoreDNS Deployment in `kube-system`. The `starfleet` namespace holds:

| Object | What it is |
| --- | --- |
| `probe`, `bridge` | Two Deployments, each behind a ClusterIP Service of the same name |
| `shuttle` | A client Deployment with `nslookup` and `wget` (busybox) |
| `partner-dns` | A second DNS server (CoreDNS) behind the Service `partner-dns`. It answers `relic.partner.example` with `192.0.2.10` and `vault.partner.example` with `192.0.2.11` |
| `crew` | A StatefulSet with two Pods behind the headless Service `crew` |

## Practice tasks

- Query `relic.partner.example.` from `shuttle`. Write down how it fails, then forward the zone `partner.example` to the `partner-dns` Service in the Corefile.
- Add a `rewrite` rule so that `deck.fleet.internal` answers with the address of the Service `bridge`.
- Read `/etc/resolv.conf` in `shuttle`, set `ndots` to 2 in the Deployment's `dnsConfig` and read the file in the new Pod.
- Look up `crew` and `crew-0.crew` and compare them with a lookup of the ClusterIP Service `probe`.
- Add the `log` plugin to the Corefile, restart CoreDNS and read the query log.
