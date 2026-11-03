---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Repair Pods That Cannot Be Reached

Two workloads in the `starfleet` namespace do not answer requests from the `shuttle` client Pod. The `relay` Deployment serves HTTP behind the Service `relay`, and the `beacon` Deployment serves HTTP behind the Service `beacon`.

## Tasks

1. Find out why `http://relay.starfleet.svc/` does not answer from `shuttle` and repair it. The Service must keep `port: 80` and `targetPort: 8080`.
2. Find out why `http://beacon.starfleet.svc/` does not answer from `shuttle` and repair it. The Service must keep `port: 80`.
3. Both URLs must return HTTP 200 when requested from the `shuttle` Pod. The `relay` Pod must also answer on its Pod IP on port 8080.

## Constraints

- Keep the images of `relay` and `beacon` unchanged.
- Do not delete and recreate the Deployments or Services.
- Do not change the `shuttle` Deployment.

Check your work with `astrona submit -c .`.
