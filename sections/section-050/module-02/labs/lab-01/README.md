---
estimated_duration: 25m
---

# Lab: Route With The Default Class, Path Types And A Default Backend

Make an IngressClass the default class and create one Ingress, without a class in its manifest, that routes by path type and has a default backend.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-050-02-01
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-default-class.sh` | `traefik` is the only default IngressClass |
| `validate-class-assigned.sh` | The Ingress `fleet` got its class from the default, not from its manifest |
| `validate-scout-prefix.sh` | `/scout/info` on `fleet.local` reaches `scout` |
| `validate-probe-prefix.sh` | `/probe/status` on `fleet.local` reaches `probe` |
| `validate-bridge-exact.sh` | `/bridge` is `Exact` and reaches `bridge`, `/bridge/extra` does not |
| `validate-default-backend.sh` | An unmatched path reaches `fallback` through `spec.defaultBackend` |
| `validate-workloads-unchanged.sh` | The controller, backends and Services are unchanged |
