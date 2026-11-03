# Prerequisites

- The `astrona` command-line tool, installed and working.
- A container engine that kind can use (Podman or Docker) with about 4 GiB of free memory.
- `kubectl`.
- You can create a Service and read DNS answers with `nslookup`.

The lab starts a kind cluster (Kubernetes 1.35) with the `probe` Deployment and Service in `starfleet`, a client Pod named `shuttle`, and the `ledger` Service in `outpost`.
