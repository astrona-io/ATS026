---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Route With The Default Class, Path Types And A Default Backend

The cluster runs the Ingress controller Traefik. It handles the IngressClass `traefik`. A second class, `legacy`, names a controller that is not installed. Neither class is the default. The `starfleet` namespace has four backends, each behind a Service on port 80: `scout`, `probe`, `bridge` and `fallback`. The Pod `shuttle` sends test requests.

## Tasks

1. Make `traefik` the default IngressClass. `legacy` must not become a default class.
2. Create the Ingress `fleet` in `starfleet` **without** `ingressClassName` in its manifest. The default class must supply the class.
3. For the host `fleet.local`, route the path `/scout` with `Prefix` to `scout`, the path `/probe` with `Prefix` to `probe`, and the path `/bridge` with `Exact` to `bridge`.
4. Set the default backend of the Ingress to the Service `fallback` on port 80, so that a request that no rule matches reaches `fallback`.

## Constraints

- Do not change the Deployments, the Services or the Traefik controller.
- Use only the one Ingress `fleet`.
- A request for `/bridge/extra` must not reach `bridge`.

Check your work with `astrona submit -c .`.
