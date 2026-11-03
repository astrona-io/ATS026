# Prerequisites

- The `astrona` command-line tool, installed and working.
- A container engine that kind can use (Podman or Docker) with about 4 GiB of free memory.
- `kubectl`.
- You can write an HTTPRoute with `parentRefs`, `hostnames`, `matches` and `backendRefs`.

The lab starts a kind cluster (Kubernetes 1.35) with the Gateway API and the Envoy Gateway controller installed.
