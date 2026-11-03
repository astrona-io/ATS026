---
estimated_duration: 25m
---

# Lab: Route, Split And Rewrite Traffic With HTTPRoute

Write one HTTPRoute with a default backend, a header match, a redirect and a rewrite.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-lab-040-02-01
```

Authors prove the reference solution with `astrona test -c .`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-route-accepted.sh` | The route `scout` has `Accepted` and `ResolvedRefs` set to `True` |
| `validate-default-goes-to-v1.sh` | A plain request reaches `scout-v1` |
| `validate-canary-header-goes-to-v2.sh` | The header `x-canary: true` reaches `scout-v2` |
| `validate-legacy-redirects.sh` | `/legacy` answers with a 301 redirect |
| `validate-echo-rewrite-and-header.sh` | `/echo/probe` reaches `echo` rewritten to `/anything/probe` with the header `x-route: scout` |
| `validate-workloads-unchanged.sh` | The workload images are unchanged |
