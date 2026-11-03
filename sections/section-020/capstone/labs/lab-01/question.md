---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Network Policies Capstone

The `drifter` client in `outpost` must call only the `scout` Service in `starfleet`, and nothing else. The `outpost` namespace must accept no incoming traffic. The `scout` Pod must accept requests only from the `shuttle` Pod in its own namespace and from the `drifter` Pod. A `visitor` Pod in the namespace `depot` must reach neither. The other workloads in `starfleet` must stay open. The cluster runs Calico, and no policy exists yet.

## Tasks

1. In `outpost`, deny all ingress and all egress for every Pod.
2. Allow `drifter` to send requests to name resolution (the CoreDNS Pods in `kube-system`, UDP and TCP port 53) and to `scout` in `starfleet` on its Pod port.
3. In `starfleet`, isolate `scout` for ingress and allow only the `shuttle` Pod of the same namespace and the `drifter` Pod of `outpost`, on the Pod port of `scout`.
4. `drifter` must reach `http://scout.starfleet.svc/`. `visitor` must not reach `scout` or the `probe` Service in `outpost`. `drifter` must not reach either `probe` Service. `shuttle` must reach `scout` and `bridge`.

## Constraints

- Do not change Deployments, Services or namespaces.
- Do not use `ipBlock`.
- Do not isolate the `probe` or `bridge` Pods in `starfleet`.

Check your work with `astrona submit -c .`.
