---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Pod Addressing And Communication

Every Pod in a cluster has its own IP address, and any Pod can reach any other Pod by that address unless a policy blocks it. This module explains where those addresses come from, which component moves the packets between nodes, and how names such as `probe.starfleet.svc` become addresses before the connection starts.

You will read the address of a running Pod, send a request to it from a Pod on another namespace, and follow a Service name through the resolver of the cluster. At the end you will be able to say, for any request that fails, whether the failure happened before the name was resolved, while the address was reached or inside the destination process.

## Learning objectives

After this module you can:

- Explain which parts of a Pod network namespace are shared between the containers of one Pod.
- Name the components that give a Pod its address and carry its traffic between nodes.
- Read the Pod IP, the node and the Pod network range of a running Pod.
- Describe how a Pod resolves a Service name, including the search list and the `ndots` option.
- Tell a resolution failure apart from a connection failure.

## Before you start

You need to know what a Pod, a Deployment, a Service and a namespace are, and you need a shell with `kubectl`. The playground is a kind cluster with one control plane node and one worker node, running Kubernetes 1.35. It has two namespaces, `starfleet` and `outpost`, with a few small applications and client Pods.

The module has two parts. The first part covers Pod addresses and the network implementation. The second part covers name resolution and Service discovery. A graded lab follows the second part.

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
