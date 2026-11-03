---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Service Types And Endpoint Relationships

A Service gives a changing set of Pods one stable address. Whether a client request reaches an application depends on four separate facts: the Service type, the selector that picks the Pods, the port mapping, and the readiness of each selected Pod. This module teaches how each fact is stored in the cluster, which component acts on it, and how to read the evidence for each one.

The rule to keep in mind is simple. A Service object only declares intent. The EndpointSlice controller turns the selector into backend records, and `kube-proxy` on every node turns those records into forwarding rules. Each step can fail alone, and each failure leaves a different trace.

## Learning objectives

After this module you can:

- Compare what ClusterIP, NodePort and LoadBalancer Services each add on top of the previous type.
- Trace a request from the Service `port` through `targetPort` to the container listener.
- Read an EndpointSlice and explain the `ready` condition of each address.
- Tell an empty selector match, a wrong target port and a failed readiness probe apart.
- Explain why a LoadBalancer Service can stay without an external address.

## Before you start

You need to know Pods, Deployments, labels, namespaces and the commands `kubectl get`, `kubectl describe` and `kubectl apply`.

The playground is a kind cluster with one control plane node and one worker node. It has the namespaces `starfleet` and `outpost`. In `starfleet`, the Deployment `probe` runs two replicas of a small Python web server that listens on port 8080, behind a Service named `probe`. The Pod `shuttle` in `starfleet` and the Pod `drifter` in `outpost` are client Pods with `wget`. The `probe` Service has a selector that matches no Pod, so you will find that fault with the commands in the parts.

## Reading order

The first part explains selectors, ports and EndpointSlices. The second part explains how NodePort, LoadBalancer and routing resources bring outside traffic to a Service. The third part gives a fixed method for diagnosing a Service that has no working backend. The module ends with a summary.

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
