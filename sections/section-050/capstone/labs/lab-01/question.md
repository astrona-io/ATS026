---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Publish An Application Through An Ingress With TLS

The `starfleet` namespace runs two applications, `web` and `api`, each behind a Service. The Ingress `portal` must publish both for the host `portal.local` over HTTPS, but no request reaches an application. The controller Traefik handles the IngressClass `traefik`. The TLS Secret `portal-tls` holds a certificate for `portal.local`. The Pod `shuttle` sends test requests and trusts that certificate.

## Tasks

1. Find out why the controller ignores the Ingress `portal` and repair it.
2. Find out why the path `/` has no backend and repair it.
3. Find out why the path `/api` does not reach `api` and repair it.
4. Terminate TLS for `portal.local` on the Ingress with the Secret `portal-tls`.
5. A request for `https://portal.local/` must reach `web`, and a request for `https://portal.local/api/v1` must reach `api` with the path unchanged. Both must pass certificate verification.

## Constraints

- Keep the host `portal.local` and the paths `/` and `/api`.
- Keep the images of the Deployments and the ports of the Service `api`.
- Do not change the Traefik controller.
- Do not disable certificate verification in any test.

Check your work with `astrona submit -c .`.
