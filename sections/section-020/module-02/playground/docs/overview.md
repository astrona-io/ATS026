---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Overview: Network Policy Patterns And Troubleshooting (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, `astrona destroy`, start over.

## What's in the box

A kind cluster with one control plane node, one worker node and the Calico network plugin, which enforces NetworkPolicy. The namespaces `starfleet` and `outpost` hold the example workloads `scout`, `probe`, `bridge` and `shuttle` in `starfleet`, and `probe` and `drifter` in `outpost`. The Services `scout`, `probe` and `bridge` listen on port 80. The `shuttle` and `drifter` Pods have `curl`.

One policy is wrong on purpose: `probe-ingress` in `starfleet` selects the `probe` Pod, but it allows the label `app: shutle` and port 8081.

## Helpers

Paste these into your shell. They send one bounded request.

```sh
from_shuttle() { kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' "$1"; }
from_drifter() { kubectl -n outpost exec deploy/drifter -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' "$1"; }
```

## Practice tasks

- Request `http://probe/` with `from_shuttle` and read how it ends. List the policies with `kubectl -n starfleet get networkpolicy` and read `probe-ingress` with `kubectl -n starfleet describe networkpolicy probe-ingress`.
- Repair `probe-ingress` so that `shuttle` reaches `probe` and `drifter` does not.
- Add a default-deny ingress policy to `starfleet` and then open the namespace to itself.
- Allow only the `drifter` Pod from `outpost` to reach `scout` on port 9898.
- Add a default-deny egress policy to `outpost` and watch name resolution fail, then allow DNS.
