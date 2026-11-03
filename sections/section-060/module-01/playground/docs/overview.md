---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Overview: How Pods Resolve Names With CoreDNS (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, `astrona destroy`, start over.

## What's in the box

A kind cluster with the default CoreDNS Deployment in `kube-system`. The `starfleet` namespace holds the Deployment `probe` (two replicas) behind the Service `probe`, and the client Pod `shuttle`. The `outpost` namespace holds the client Pod `drifter`. The client Pods use the busybox image, which has `nslookup` and `wget`.

The Corefile is the default one. It is healthy when the playground starts.

## Practice tasks

- Read `/etc/resolv.conf` in `shuttle` and in `drifter` and compare the `search` lines.
- Look up `probe`, `probe.starfleet` and `probe.outpost` from both client Pods.
- Print the Corefile from the ConfigMap `coredns` and name the plugin that answers `cluster.local` names.
- Save a backup of the Corefile, add an unknown directive, restart the Deployment and read the log of the new Pod.
- Restore the backup, restart the Deployment again and verify one cluster name.
