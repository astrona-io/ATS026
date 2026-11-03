# Prerequisites

- The `astrona` command-line tool, installed and working.
- A container engine that kind can use (Podman or Docker) with about 4 GiB of free memory.
- `kubectl`.
- You can write an Ingress with rules, paths and a backend, and you can annotate an object with `kubectl annotate`.

The lab starts a kind cluster (Kubernetes 1.35) with Traefik, two IngressClasses, four backends in `starfleet` and a `curl` client Pod.
