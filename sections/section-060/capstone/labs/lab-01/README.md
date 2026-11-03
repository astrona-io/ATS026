---
estimated_duration: 40m
---

# Lab: CoreDNS Capstone

Repair per-Pod DNS names of a StatefulSet, add a rewrite rule to the Corefile, give one Deployment its own resolver and scale CoreDNS.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-060-capstone-01
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-crew-pod-names.sh` | `crew-0.crew.starfleet.svc.cluster.local` resolves to the Pod IP of `crew-0` |
| `validate-crew-service-contract.sh` | The Service `crew` is headless, keeps port 80, and the StatefulSet has two Pods |
| `validate-rewrite-resolves.sh` | `deck.fleet.internal` resolves to the ClusterIP of `bridge` |
| `validate-corefile-keeps-default-block.sh` | The Corefile keeps the `kubernetes` and `forward` directives |
| `validate-auditor-own-resolver.sh` | `auditor` uses policy `None` with the `partner-dns` server and resolves `relic.partner.example` |
| `validate-coredns-scaled.sh` | The `coredns` Deployment has three ready replicas |
