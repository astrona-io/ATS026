---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Isolate A Namespace With Network Policies

The `starfleet` namespace has the workloads `scout`, `probe` and `bridge` with the Services of the same names, and the client `shuttle`. The `drifter` client in the `outpost` namespace reaches every one of them. No NetworkPolicy exists yet, and the cluster runs Calico, which enforces them.

## Tasks

1. Isolate every Pod in `starfleet` for ingress, so that a Pod no policy allows accepts nothing.
2. Keep the traffic between Pods inside `starfleet` working. The `shuttle` Pod must still reach `http://bridge.starfleet.svc/`.
3. Allow the `drifter` Pod in `outpost`, and no other Pod, to reach `http://scout.starfleet.svc/`.
4. The `drifter` Pod must not reach `http://bridge.starfleet.svc/` or `http://probe.starfleet.svc/`.

## Constraints

- Create the policies in `starfleet`. Do not create any policy in `outpost`.
- Do not change the Deployments or Services.
- Do not use `ipBlock`.

Check your work with `astrona submit -c .`.
