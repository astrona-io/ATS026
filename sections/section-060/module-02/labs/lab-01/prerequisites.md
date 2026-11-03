# Prerequisites

- The `astrona` command-line tool, installed and working.
- A container engine that kind can use (Podman or Docker) with about 4 GiB of free memory.
- `kubectl`.
- You can read and edit a ConfigMap and restart a Deployment with kubectl.

The lab starts a kind cluster (Kubernetes 1.35) with the example workloads in the `starfleet` namespace and a second DNS server named `partner-dns`.
