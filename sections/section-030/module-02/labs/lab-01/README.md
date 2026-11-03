---
estimated_duration: 25m
---

# Lab: Headless Service, ExternalName And Session Affinity

Create a headless Service and an ExternalName Service, and turn on session affinity for an existing Service.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-030-02-01
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-headless-service.sh` | `probe-pods` is headless and selects the probe Pods |
| `validate-headless-dns.sh` | The DNS name returns the Pod addresses |
| `validate-ledger-externalname.sh` | `ledger` in `starfleet` is an ExternalName Service that answers |
| `validate-probe-session-affinity.sh` | `probe` has ClientIP affinity with a 600 second timeout |
| `validate-requests-stick-to-one-pod.sh` | Twelve requests reach one Pod |
| `validate-probe-unchanged.sh` | `probe` keeps its ClusterIP and port, and the images are unchanged |
