---
estimated_duration: 25m
---

# Lab: Forward A Stub Domain And Tune Pod DNS

Forward the zone `partner.example` to a second DNS server in the CoreDNS Corefile, and set the `ndots` option for one client Deployment.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-060-02-01
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-stub-domain-resolves.sh` | `relic.partner.example` resolves to 192.0.2.10 from the shuttle client |
| `validate-cluster-names-still-resolve.sh` | `probe.starfleet.svc.cluster.local` still resolves to the Service ClusterIP |
| `validate-corefile-keeps-default-block.sh` | The Corefile still has the `kubernetes` and `forward` directives |
| `validate-coredns-running.sh` | The CoreDNS Deployment is fully ready |
| `validate-shuttle-ndots.sh` | The shuttle Pod has `ndots:2` and still resolves `probe` |
