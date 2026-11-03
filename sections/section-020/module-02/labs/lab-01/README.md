---
estimated_duration: 25m
---

# Lab: Isolate A Namespace With Network Policies

Isolate a namespace for ingress, keep its own traffic and admit one client from another namespace.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-020-02-01
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-shuttle-reaches-bridge.sh` | Traffic inside starfleet still works |
| `validate-drifter-reaches-scout.sh` | The drifter Pod reaches scout |
| `validate-drifter-blocked-from-bridge.sh` | The drifter Pod cannot reach bridge |
| `validate-drifter-blocked-from-probe.sh` | The drifter Pod cannot reach probe |
| `validate-outpost-has-no-policy.sh` | Nothing was changed in outpost |
