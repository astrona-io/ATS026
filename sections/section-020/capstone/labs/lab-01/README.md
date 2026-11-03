---
estimated_duration: 35m
---

# Lab: Network Policies Capstone

Combine default deny for both directions, namespace and Pod selectors and a DNS egress rule.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-020-capstone-01
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-drifter-reaches-scout.sh` | drifter reaches scout by name |
| `validate-drifter-blocked-from-probe-starfleet.sh` | drifter cannot reach probe in starfleet |
| `validate-drifter-blocked-from-probe-outpost.sh` | drifter cannot reach probe in outpost |
| `validate-visitor-blocked-from-outpost-probe.sh` | outpost is isolated for ingress |
| `validate-visitor-blocked-from-scout.sh` | scout admits only drifter and shuttle |
| `validate-shuttle-reaches-scout.sh` | starfleet clients still reach scout |
| `validate-shuttle-reaches-bridge.sh` | other Pods in starfleet stay open |
