---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Repair A Network Policy

The Service `probe` in `starfleet` is protected by the NetworkPolicy `probe-ingress`. The `shuttle` Pod in the same namespace must reach `http://probe.starfleet.svc/`, but its requests time out. The `drifter` Pod in `outpost` must stay blocked.

## Tasks

1. Find out why `shuttle` cannot reach `probe`. Check the Service endpoints, the policy, the labels and the port.
2. Repair the policy `probe-ingress` so that `shuttle` gets HTTP 200 from `http://probe.starfleet.svc/`.
3. `drifter` must still not reach `http://probe.starfleet.svc/`.

## Constraints

- Edit the existing policy. Do not delete it and do not create another policy.
- Do not change the Deployments or Services.
- Do not admit every source.

Check your work with `astrona submit -c .`.
