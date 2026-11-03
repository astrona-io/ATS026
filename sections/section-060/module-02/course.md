---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Customise And Debug CoreDNS

The default CoreDNS configuration serves most clusters, but real clusters need more. A partner network has its own DNS zone, an old application uses a name that no Service carries, a Pod needs a different resolver, and a StatefulSet needs one stable name per Pod. This module teaches the settings that control each of these cases and the checks that find a fault when one goes wrong.

The module follows one rule: **change the smallest piece that fixes the problem, and verify one cluster name and one outside name after every change.**

## Learning objectives

After this module you can:

- Read a Corefile as server blocks and plugins and say what the `errors`, `health`, `ready`, `kubernetes`, `forward`, `cache`, `loop`, `reload` and `rewrite` plugins do.
- Send one DNS zone to another DNS server with a second server block.
- Rewrite a requested name to a Service name.
- Choose a Pod `dnsPolicy` and set `dnsConfig` fields, and explain how `ndots` and search domains change the queries a Pod sends.
- Explain the DNS records of a headless Service, a StatefulSet Pod and a named port.
- Scale CoreDNS, turn on query logging and restart the Deployment after a ConfigMap change.

## Before you start

You need to know Pods, Deployments, Services, StatefulSets, ConfigMaps and the commands `kubectl get`, `kubectl exec`, `kubectl logs` and `kubectl apply`. You need to know that CoreDNS answers cluster names through the `kube-dns` Service and that its Corefile is stored in the ConfigMap `coredns` in `kube-system`.

The playground is a kind cluster with one control plane node and one worker node. The `starfleet` namespace holds the healthy Services `probe` and `bridge`, the client Deployment `shuttle`, a second DNS server named `partner-dns` that answers the zone `partner.example`, and a StatefulSet `crew` behind a headless Service.

The module has four parts. The first part explains the Corefile, stub domains and the rewrite plugin. The second part explains Pod DNS settings. The third part explains the records of headless Services and StatefulSet Pods. The fourth part explains scaling and debugging.

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
