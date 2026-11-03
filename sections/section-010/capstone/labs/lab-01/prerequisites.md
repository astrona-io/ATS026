# Prerequisites

- The `astrona` command-line tool, installed and working.
- A container engine that kind can use (Podman or Docker) with about 4 GiB of free memory.
- `kubectl`.
- You can read a Service, an EndpointSlice and a ConfigMap with kubectl, and you can start a request from a client Pod with `kubectl exec`.

The lab starts a kind cluster (Kubernetes 1.35) with the example workloads in `starfleet` and `outpost`.
