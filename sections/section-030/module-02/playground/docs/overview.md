---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Overview: Headless Services, ExternalName And Traffic Policy (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, `astrona destroy`, start over.

## What's in the box

In `starfleet`, the Deployment `probe` runs three replicas of a `podinfo` web server (container port name `http`, port 9898) behind the ClusterIP Service `probe` on port 80. The Deployment `shuttle` runs one `busybox` client Pod with `wget` and `nslookup`. In `outpost`, the Deployment `ledger` runs one `podinfo` Pod behind the Service `ledger`. The cluster has one control plane node and one worker node.

## Helpers

Paste these into your shell. They run one command from the `shuttle` Pod.

```sh
from_shuttle() { kubectl -n starfleet exec deploy/shuttle -- "$@"; }
which_pod() { from_shuttle wget -q -T 3 -O- "$1" | grep -o '"hostname": *"[^"]*"'; }
```

## Practice tasks

- Run `which_pod http://probe/` ten times and count how many different Pod names answer.
- Create a headless Service for `probe` with `clusterIP: None`, then run `from_shuttle nslookup <name>.starfleet.svc.cluster.local` and compare the addresses with `kubectl -n starfleet get pods -o wide`.
- Scale `probe` to 5 replicas and look up the headless name again.
- Create an `ExternalName` Service that points to `ledger.outpost.svc.cluster.local` and request it from `shuttle`.
- Set `sessionAffinity: ClientIP` on the Service `probe` and repeat the ten requests.
- Read the `kube-proxy` mode with `kubectl -n kube-system get configmap kube-proxy -o yaml`.
