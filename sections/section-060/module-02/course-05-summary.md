---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Summary

A Corefile is a list of server blocks, and each block is a zone with a list of plugins. CoreDNS picks the block with the longest matching zone. The default block answers cluster names with the `kubernetes` plugin and sends all other names upstream with `forward`. A stub domain is an extra server block that forwards one zone to another DNS server. A `rewrite` rule with the type `exact` changes the requested name before the other plugins see it and changes it back in the answer. Both changes must keep the default block, or cluster names stop working.

The Pod decides what it sends to CoreDNS. The `dnsPolicy` field chooses the base of `/etc/resolv.conf`: `ClusterFirst` uses `kube-dns`, `Default` uses the node's resolvers, and `None` uses only `dnsConfig`. The `dnsConfig` field adds name servers, search domains and options. The `ndots` option sets how many dots a name needs before the resolver tries it as written, and the default of 5 makes most external names cost several extra queries. A name that ends with a dot is absolute. The kubelet writes the file once, so only new Pods carry a change.

The Service type decides which records exist. A ClusterIP Service has one A record. A headless Service has one A record for each ready Pod. A StatefulSet with a headless governing Service also gets one stable record for each Pod, and named ports get SRV records. An ExternalName Service gives a CNAME record.

CoreDNS needs the same checks as any other workload. Check the Deployment, the Pods and the EndpointSlice of `kube-dns`, then the client's resolver file, then a lookup by full name, then the logs. The `log` plugin shows each query and its response code. A ConfigMap change does not restart the Pods, so run `kubectl rollout restart` and wait for the rollout. More replicas fix load problems and do not fix configuration errors.

Key facts to remember:

- Keep the default `.:53` block when you add a block or a rule.
- `Default` is not the default DNS policy; `ClusterFirst` is.
- `clusterIP: None` makes a Service headless, and the field cannot be changed later.
- Restart CoreDNS after each Corefile change and check one cluster name and one outside name.

<!-- astrona:playground:destroy -->
