---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# How Pods Resolve Names With CoreDNS

A Pod that calls `http://probe/` never uses an IP address. Something has to turn the name `probe` into the address of the Service, and when that step fails, healthy application Pods still cannot talk to each other. This module explains which component answers each DNS query, how the Pod finds that component, and how to find the broken link when a lookup fails.

The module follows one rule: **test the name lookup on its own before you test the application connection.** A lookup that returns the right address and a connection that still fails are two different problems with two different fixes.

## Learning objectives

After this module you can:

- Read `/etc/resolv.conf` inside a Pod and name the DNS server, the search domains and the `ndots` option.
- Write the fully qualified name of a Service and explain how a short name expands to it.
- Read a default Corefile and say what the `kubernetes`, `forward`, `cache`, `loop` and `reload` directives do.
- Tell a cluster name failure from an upstream name failure.
- Find a Corefile syntax error in the CoreDNS logs, restore the Corefile and restart the CoreDNS Deployment.

## Before you start

You need to know Pods, Services, namespaces, ConfigMaps and the commands `kubectl get`, `kubectl exec` and `kubectl logs`.

The playground is a kind cluster with the example workloads. In the `starfleet` namespace the `probe` Deployment sits behind the Service `probe`, and the `shuttle` Pod is a client with the `nslookup` and `wget` tools. The `outpost` namespace has a client Pod named `drifter`. The cluster runs the default CoreDNS Deployment in `kube-system`.

The module has two parts. The first part follows one query from the Pod to the answer. The second part shows what a Corefile error does to the cluster and how to repair it.

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
