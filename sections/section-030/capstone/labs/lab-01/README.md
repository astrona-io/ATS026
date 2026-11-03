---
estimated_duration: 30m
---

# Lab: Services And Endpoints Capstone

Repair a Service, expose it on a node port, add a headless Service and turn on session affinity.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-030-capstone-01
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-probe-has-backends.sh` | `probe` has three ready endpoints |
| `validate-probe-answers.sh` | `http://probe/` answers 200 |
| `validate-probe-nodeport.sh` | `probe` is a NodePort Service on 30090 and answers on each node address |
| `validate-probe-peers-headless.sh` | `probe-peers` is headless and returns the Pod addresses |
| `validate-probe-affinity.sh` | `probe` uses ClientIP affinity with a 300 second timeout |
| `validate-unchanged.sh` | The Deployment is unchanged and the Service was not recreated |
