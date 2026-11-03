---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Traffic Isolation And Enforcing Implementations

By default every Pod accepts traffic from every other Pod and can send traffic to any destination. A NetworkPolicy changes this for the Pods it selects: they accept and send only the traffic that some policy allows. This module explains how a policy selects Pods, how allowed peers and ports are written, how egress and DNS fit in, and why a policy has no effect when the network plugin does not enforce it.

## Learning objectives

After this module you can:

- Explain when a Pod becomes isolated and what isolation means for ingress and egress.
- Write ingress rules with Pod selectors, namespace selectors, IP blocks and ports.
- Combine selectors in one peer entry and in separate entries and predict the result.
- Write egress rules that keep DNS working.
- Explain why a policy needs a network plugin that enforces it.

## Before you start

You need the Pod and Service basics and the commands `kubectl apply`, `kubectl get` and `kubectl exec`. The playground is a kind cluster with Calico as network plugin, one control plane node and one worker node. It has two namespaces, `starfleet` and `outpost`, with small web applications and curl client Pods.

The module has two parts. The first part covers ingress policy and allowed peers, and a graded lab follows it. The second part covers egress policy and DNS, and a second graded lab follows it.

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
