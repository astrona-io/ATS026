---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Headless Services, ExternalName And Traffic Policy

A ClusterIP Service with a selector is the most common case, but not the only one. Some clients need the real Pod addresses and not one virtual address. Some applications need a local name for something outside the namespace or outside the cluster. Some requests must stay on one Pod, and some must stay on one node. Kubernetes covers these cases with Service variants and a few fields that change how `kube-proxy` and the cluster DNS server answer.

The rule to keep in mind: the Service type and its fields change two things only, the answer of the cluster DNS server and the forwarding rules on the nodes. Reading those two places tells you what a Service really does.

## Learning objectives

After this module you can:

- Create a headless Service and explain what the DNS server returns for it.
- Create an ExternalName Service and explain why it forwards nothing.
- Write a Service without a selector and give it addresses with an EndpointSlice.
- Turn on session affinity and explain how long it lasts and what it uses to identify a client.
- Explain `externalTrafficPolicy` and `internalTrafficPolicy` and name the `kube-proxy` modes.

## Before you start

You need to know ClusterIP Services, selectors, EndpointSlices and how to run a command in a Pod with `kubectl exec`.

The playground has three `probe` Pods behind the Service `probe` in `starfleet`, a client Pod named `shuttle` with `wget` and `nslookup`, and a `ledger` Service with one Pod in `outpost`.

## Reading order

The first part covers the Service variants that change DNS answers: headless, ExternalName and selectorless Services. The second part covers session affinity, traffic policies and `kube-proxy` modes. The module ends with a summary. The task for this module comes after the second part.

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
