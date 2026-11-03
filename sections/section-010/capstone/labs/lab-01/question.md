---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Repair Three Unreachable Workloads

Three workloads in the `starfleet` namespace do not answer requests. The client is the `drifter` Pod in the `outpost` namespace, which reaches each workload through its Service name with the namespace, for example `http://signal.starfleet.svc/`. The Deployments are `signal`, `lantern` and `dock`, each behind a Service of the same name.

## Tasks

1. Find the cause for each of the three workloads and repair it.
2. `http://signal.starfleet.svc/`, `http://lantern.starfleet.svc/` and `http://dock.starfleet.svc/` must return HTTP 200 when requested from the `drifter` Pod.
3. The `signal` Pod must also answer on its Pod IP on port 8080.

## Constraints

- Every Service keeps `port: 80`. The `signal` Service keeps `targetPort: 8080` and the `dock` Service keeps `targetPort: 9898`.
- Keep the container images of all three Deployments unchanged.
- Do not create a NetworkPolicy. None of the faults is a policy.
- Do not delete and recreate the Deployments or Services.

Check your work with `astrona submit -c .`.
