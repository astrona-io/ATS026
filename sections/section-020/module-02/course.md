---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Network Policy Patterns And Troubleshooting

Single policies are easy to read. A real namespace has several of them, written by different people, and the result is the union of all rules that select a Pod. This module covers the patterns that appear in almost every cluster, such as default deny and namespace isolation, and a method to find out why a policy blocks or allows the wrong traffic.

## Learning objectives

After this module you can:

- Create default-deny policies for ingress, egress and both.
- Build a namespace that accepts traffic only from itself and from named peers.
- Use `ipBlock` with `except` and port ranges with `endPort`.
- Predict the combined effect of several policies on one Pod.
- Find the cause of a policy that blocks too much or too little.

## Before you start

You need to know how a policy selects Pods, how rules list peers and ports, and that a dropped packet looks like a timeout. The playground is a kind cluster with Calico, one control plane node and one worker node, with `starfleet` and `outpost` workloads and one policy that is wrong on purpose.

The module has two parts. The first part covers the common patterns, and a graded lab follows it. The second part covers troubleshooting, and a second graded lab follows it.

Launch your playground now and keep it running next to you while you read:

<!-- astrona:playground -->
