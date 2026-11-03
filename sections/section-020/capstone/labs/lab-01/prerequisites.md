# Prerequisites

- The `astrona` command-line tool, installed and working.
- A container engine that kind can use (Podman or Docker) with about 4 GiB of free memory.
- `kubectl`.
- You can read and write a NetworkPolicy with a `podSelector`, `policyTypes`, `ingress` and `egress`.

The lab starts a kind cluster (Kubernetes 1.35) with the Calico network plugin, which enforces NetworkPolicy, and the example workloads in `starfleet` and `outpost`.
The lab also has a `depot` namespace with a `visitor` client Pod.
