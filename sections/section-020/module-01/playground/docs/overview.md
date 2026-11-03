---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Overview: Traffic Isolation And Enforcing Implementations (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, `astrona destroy`, start over.

## What's in the box

A kind cluster with Calico as network plugin, so NetworkPolicy is enforced. Namespaces `starfleet` and `outpost`. In `starfleet`: `scout`, `probe` (httpbin on port 8080), `bridge` (NGINX on port 80) and the client `shuttle`. In `outpost`: a `probe` Service and the client `drifter`. No NetworkPolicy exists at the start.

## Helpers

Paste these into your shell. They print one status code, or the curl exit code when a request fails.

```sh
from_shuttle() { kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' "$1"; echo "exit: $?"; }
from_drifter() { kubectl -n outpost exec deploy/drifter -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' "$1"; echo "exit: $?"; }
policies() { kubectl get networkpolicy -A; }
```

## Practice tasks

- Check that both clients reach `bridge` before any policy exists.
- Apply a policy that allows only `shuttle` to reach `bridge` and confirm `drifter` is dropped.
- Change the `from` list so that one entry has two selectors and compare it with two separate entries.
- Isolate `shuttle` for egress, then remove the DNS rule and watch name resolution fail.
- Delete every policy and confirm that traffic is open again.
