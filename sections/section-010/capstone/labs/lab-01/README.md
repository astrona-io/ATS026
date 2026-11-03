---
estimated_duration: 30m
---

# Lab: Understand Connectivity Between Pods Capstone

Repair three workloads in `starfleet` that the `drifter` client in `outpost` cannot reach: a server bound to the loopback address, a Service with a wrong target port and a Service whose selector matches no Pod.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-010-capstone
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-signal-answers.sh` | The signal Service answers HTTP 200 from `drifter` |
| `validate-signal-pod-ip.sh` | The signal Pod answers on its Pod IP |
| `validate-lantern-answers.sh` | The lantern Service answers HTTP 200 from `drifter` |
| `validate-dock-answers.sh` | The dock Service answers HTTP 200 from `drifter` |
| `validate-dock-has-endpoint.sh` | The dock Service has a ready endpoint |
| `validate-service-contract-kept.sh` | Service ports are kept |
| `validate-images-unchanged.sh` | The images are unchanged |
| `validate-no-networkpolicy.sh` | No NetworkPolicy exists |
