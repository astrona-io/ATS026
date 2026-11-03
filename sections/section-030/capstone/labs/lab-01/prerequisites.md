# Prerequisites

- The `astrona` command-line tool, installed and working.
- A container engine that kind can use (Podman or Docker) with about 4 GiB of free memory.
- `kubectl`.
- You can read a Service and its EndpointSlices, and you know the Service types ClusterIP, NodePort and headless.

The lab starts a kind cluster (Kubernetes 1.35) with the `probe` Deployment, a faulty `probe` Service and a client Pod named `shuttle` in `starfleet`.
