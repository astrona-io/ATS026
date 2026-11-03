---
estimated_duration: 35m
---

# Capstone: Publish An Application Through An Ingress With TLS

Repair an Ingress that serves two backends over HTTPS. Four independent faults sit in the path: a class without a controller, a Service with an empty selector match, a wrong backend port and a missing TLS section.

**Status: UNTESTED.** Built and checked statically only (configuration validation, shell and YAML syntax). It has not been run.

## Run it

```sh
astrona run -c .
astrona submit -c .
astrona destroy ats-026-capstone-050-01
```

Authors prove the reference solution with `astrona test -c .`. The bootstrap script needs `openssl` on the host to create the self-signed certificate.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-portal-class.sh` | The Ingress `portal` selects the class `traefik` |
| `validate-web-endpoints.sh` | The Service `web` has a ready endpoint |
| `validate-api-backend-port.sh` | The `/api` path points at a port of the Service `api` |
| `validate-tls-config.sh` | The Ingress terminates TLS for `portal.local` with `portal-tls` |
| `validate-https-web.sh` | `https://portal.local/` reaches `web` with a verified certificate |
| `validate-https-api.sh` | `https://portal.local/api/v1` reaches `api` with a verified certificate |
| `validate-unmatched-host.sh` | Another host does not reach an application |
| `validate-workloads-unchanged.sh` | Images, the `api` Service, the host and the controller are unchanged |
