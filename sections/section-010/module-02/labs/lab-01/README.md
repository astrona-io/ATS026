---
estimated_duration: 25m
---

# Lab: Repair Pods That Cannot Be Reached

Repair two workloads that cannot be reached: a server bound to the loopback address and a Service with a wrong target port.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-010-02-01
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-relay-answers.sh` | The relay Service answers HTTP 200 from the shuttle client |
| `validate-relay-pod-ip.sh` | The relay Pod answers on its Pod IP, not only on the loopback address |
| `validate-beacon-answers.sh` | The beacon Service answers HTTP 200 from the shuttle client |
| `validate-services-keep-port-80.sh` | Both Services still expose port 80 and relay still forwards to 8080 |
| `validate-images-unchanged.sh` | The relay and beacon images are unchanged |
