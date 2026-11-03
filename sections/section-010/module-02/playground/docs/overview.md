---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Overview: Diagnose Pod-To-Pod Connectivity (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, `astrona destroy`, start over.

## What's in the box

Namespaces `starfleet` and `outpost` with the healthy example workloads `scout`, `probe`, `bridge`, `shuttle` and `drifter`. Three broken workloads in `starfleet`: `relay` (server bound to `127.0.0.1`), `beacon` (Service `targetPort` 8080 but the container listens on 9898) and `hold` (readiness probe always fails). The cluster has one control plane node and one worker node.

## Helpers

Paste these into your shell. They send one bounded request from the `shuttle` client Pod.

```sh
from_shuttle() { kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' "$1"; }
ends() { kubectl -n starfleet exec deploy/shuttle -- curl -sS --max-time 3 -o /dev/null "$1"; echo "exit code: $?"; }
slices() { kubectl -n starfleet get endpointslices -l kubernetes.io/service-name="$1"; }
```

## Practice tasks

- Request `http://relay/`, `http://beacon/` and `http://hold/` with `ends` and write down how each one ends.
- Read the Pod IP of `scout` with `kubectl get pods -o wide` and request it directly.
- Add an ephemeral debug container to a `relay` Pod and test `127.0.0.1:8080` from inside the Pod.
- Compare the `beacon` Service `targetPort` with the container port, then repair it with `kubectl patch`.
- Run `kubectl describe pod` on `hold` and find the failed readiness probe in the events.
