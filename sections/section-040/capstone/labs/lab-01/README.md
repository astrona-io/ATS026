---
estimated_duration: 40m
---

# Capstone Lab: Repair Gateway Routes Across Namespaces

Three routes on one Gateway have three different faults: a namespace that is not allowed to attach, a Service reference without a grant, and a canary split with reversed weights.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-040-capstone-01
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-drifter-attached.sh` | The route `drifter` in `outpost` is accepted and reaches the Service `drifter` |
| `validate-stock-reference-granted.sh` | The route `stock` reaches the Service `stock` in `catalog` |
| `validate-grant-is-narrow.sh` | The grant names only `stock` and only routes from `starfleet`, and `catalog` has no access label |
| `validate-scout-canary-and-weights.sh` | The header `x-canary: true` reaches `scout-v2` |
| `validate-scout-weights.sh` | The default rule has weights 90 and 10 |
| `validate-gateway-not-widened.sh` | The Gateway keeps its selector and the workload images are unchanged |
