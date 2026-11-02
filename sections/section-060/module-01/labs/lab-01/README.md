---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Restore A Broken CoreDNS Configuration

Trace failed name resolution to a Corefile syntax error and restore the saved configuration.

The task and solution use a separate pinned kind cluster. Run `testing/smoke.sh` with its private kubeconfig to verify initial rejection and reference success. Static validation is not live evidence. Runtime verification remains pending.
