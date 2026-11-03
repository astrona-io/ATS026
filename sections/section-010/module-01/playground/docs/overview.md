---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Overview: Pod Addressing And Communication (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, `astrona destroy`, start over.

## What's in the box

Namespaces `starfleet` and `outpost`. In `starfleet`: `scout` (podinfo on port 9898, Service `scout` on port 80), `probe` (httpbin on port 8080, Service `probe` on port 80), `bridge` (NGINX with a Service) and the client `shuttle` with curl. In `outpost`: a second `probe` Service and the client `drifter`. The cluster has one control plane node and one worker node.

## Helpers

Paste these into your shell. They run curl from a client Pod and print one status code.

```sh
from_shuttle() { kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' "$1"; }
from_drifter() { kubectl -n outpost exec deploy/drifter -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' "$1"; }
pod_ip() { kubectl -n "$1" get pod -l app="$2" -o jsonpath='{.items[0].status.podIP}{"\n"}'; }
```

## Practice tasks

- Read the IP and node of every Pod with `kubectl get pods -A -o wide`.
- Request the `scout` Pod IP on port 9898 from `drifter`.
- Read `/etc/resolv.conf` in `shuttle` and in `drifter` and compare the search lines.
- Request `http://probe/` from `shuttle` and from `drifter` and explain why each reaches a different Service.
- Request a name that does not exist and read the curl exit code.
