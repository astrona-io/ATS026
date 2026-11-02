---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Trace DNS To A Service Address

Compare a resolved Service name with the actual ClusterIP and repeat the application request.

The task and solution use a separate pinned kind cluster. Run `testing/smoke.sh` with its private kubeconfig to verify initial rejection and reference success. Static validation is not live evidence. Runtime verification remains pending.
