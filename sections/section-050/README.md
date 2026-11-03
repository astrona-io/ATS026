---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Know how to use Ingress controllers and Ingress resources

A client requests `probe.local`, and Traefik chooses an Ingress route before forwarding to the `probe` Service. The Ingress object declares matching rules; the controller implements them. A rule stored without a controller that owns its class does nothing.

This section teaches how an Ingress selects a controller, how the controller chooses a rule from the host and the path, and how to find the first failing step when a request does not reach the application. Each module has a playground, and each module ends with a graded lab.

## Learning outcomes

- Explain why an Ingress without a matching controller and IngressClass does nothing.
- Make one IngressClass the default class and predict which Ingresses it affects.
- Write `Exact` and `Prefix` paths, wildcard hosts and a default backend, and predict which rule a request matches.
- Map the Ingress backend port to the Service port and the Service `targetPort`.
- Explain what TLS termination at the controller protects.
- Tell a response from the controller apart from a response from the application, and name the evidence for it.

## Modules

| Module | Topic |
| --- | --- |
| module-01 | Ingress selection and request diagnosis: the controller contract, host and path matching, backend ports, TLS and tracing a request |
| module-02 | Choosing a controller, class, paths and hosts: IngressClass, the default class, path types, precedence and the default backend |

## Labs

| Lab | Task |
| --- | --- |
| module-01 lab-01 | Route a matching host through Ingress |
| module-01 lab-02 | Verify TLS termination and server identity |
| module-02 lab-01 | Route with the default class, path types and a default backend |
| capstone lab-01 | Publish an application through an Ingress with TLS (advanced) |

## Knowledge check

`quiz.yaml` holds 12 single-choice questions with an explanation for every option. It follows the capstone.

## Status

The module-02 labs and the capstone are **UNTESTED**. They were built and checked statically only (configuration validation, shell syntax and YAML parsing) and have not been run against a live cluster.
