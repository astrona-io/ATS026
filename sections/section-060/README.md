---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Understand and use CoreDNS

A Pod resolves public names but not a Service name, while another Pod cannot reach the resolver at all. These symptoms point to different places on the path of a DNS query. This section follows the query from the Pod to CoreDNS and back, and then changes each link of the path in a running cluster.

Module 01 covers the query path: the resolver file of a Pod, the search list and `ndots`, the Corefile in the ConfigMap `coredns`, and what happens when the Corefile is broken. Module 02 covers the changes an administrator makes: plugins, a stub domain and a rewrite rule, `dnsPolicy` and `dnsConfig`, headless Services and Pod records, and scaling and debugging CoreDNS. The capstone lab combines four of these changes in one cluster, and a knowledge check closes the section.

Each module starts a playground, a cluster where you run the commands of the lessons, and each module ends with a graded lab. The capstone lab and the quiz come after the second module. The lessons name the commands, and the labs grade the state of the cluster.

## Learning Outcomes

- Explain how a Pod's `/etc/resolv.conf`, the `search` list and `ndots` turn a short name into a query.
- Read a Corefile and name the job of the `kubernetes`, `forward`, `cache`, `loop`, `reload` and `rewrite` plugins.
- Diagnose a broken Corefile from the Pod state and logs, and restore it from a backup.
- Forward a stub domain to another DNS server and rewrite a name to a Service.
- Choose a `dnsPolicy` and a `dnsConfig` for a Pod, and predict the effect of `ndots`.
- Explain the DNS records of ClusterIP and headless Services, and per-Pod names of a StatefulSet.
- Scale CoreDNS and apply a configuration change safely.
