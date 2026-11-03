---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Headless Service, ExternalName And Session Affinity

The `probe` Deployment in `starfleet` runs three Pods behind the Service `probe`. A client in `starfleet` named `shuttle` needs the Pod addresses directly, a stable local name for the `ledger` Service in `outpost`, and requests that stay on one Pod.

## Tasks

1. Create a Service `probe-pods` in `starfleet` that is headless, selects the Pods with `app: probe` and exposes port 80 with `targetPort: http`. A DNS lookup of `probe-pods.starfleet.svc.cluster.local` from `shuttle` must return the addresses of the three `probe` Pods.
2. Create a Service `ledger` in `starfleet` of type `ExternalName` that points to `ledger.outpost.svc.cluster.local`. A request to `http://ledger/` from `shuttle` must answer.
3. Change the existing Service `probe` so that requests from one client address go to the same Pod. Use a timeout of 600 seconds.

## Constraints

- Do not delete and recreate the Service `probe`. It keeps its ClusterIP and port 80.
- Do not change the Deployments or their images.

Check your work with `astrona submit -c .`.
