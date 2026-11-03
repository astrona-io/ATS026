---
estimated_duration: 20m
---

# Lab: Repair A Network Policy

Find and fix a policy with a wrong label and a wrong port.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-020-02-02
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-shuttle-reaches-probe.sh` | The shuttle Pod reaches probe |
| `validate-drifter-blocked-from-probe.sh` | The drifter Pod stays blocked |
| `validate-probe-ingress-kept.sh` | The existing policy was edited, not replaced |
