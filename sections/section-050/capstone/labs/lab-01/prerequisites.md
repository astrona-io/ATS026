# Prerequisites

- The `astrona` command-line tool, installed and working.
- A container engine that kind can use (Podman or Docker) with about 4 GiB of free memory.
- `kubectl` and `openssl`.
- You can read an Ingress, a Service, an EndpointSlice and a TLS Secret with kubectl.

The lab starts a kind cluster (Kubernetes 1.35) with Traefik, the applications `web` and `api` in `starfleet`, a TLS Secret and a `curl` client Pod.
