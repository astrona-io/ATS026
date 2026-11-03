# Curriculum Coverage

Exam: Certified Kubernetes Administrator (CKA). Domain: Services & Networking (20%).

The [official objectives](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/) were verified on 2026-10-11. Teaching structure is original; it does not add official exam requirements.

| Section | Official objective | Modules |
| --- | --- | --- |
| 010 | Understand connectivity between Pods | 2 |
| 020 | Define and enforce Network Policies | 2 |
| 030 | Use ClusterIP, NodePort, LoadBalancer service types and endpoints | 2 |
| 040 | Use the Gateway API to manage Ingress traffic | 2 |
| 050 | Know how to use Ingress controllers and Ingress resources | 2 |
| 060 | Understand and use CoreDNS | 2 |

| Section / module | Module |
| --- | --- |
| 010 / 01 | Pod Addressing And Communication |
| 010 / 02 | Diagnose Pod-To-Pod Connectivity |
| 020 / 01 | Traffic Isolation And Enforcing Implementations |
| 020 / 02 | Network Policy Patterns And Troubleshooting |
| 030 / 01 | Service Types And Endpoint Relationships |
| 030 / 02 | Headless Services, ExternalName And Traffic Policy |
| 040 / 01 | Gateway Classes, Listeners And Routes |
| 040 / 02 | Matches, Weights, Filters And Cross-Namespace Routes |
| 050 / 01 | Ingress Selection And Request Diagnosis |
| 050 / 02 | Choose A Controller, Class, Paths And Hosts |
| 060 / 01 | How Pods Resolve Names With CoreDNS |
| 060 / 02 | Customise And Debug CoreDNS |

The module goals and adaptation sources are recorded in AUTHORING.yaml. Every official objective is covered. Each section starts with an introduction, each module ends with a summary, each section ends with a capstone lab and a `quiz.yaml`, and `sections/final-domain-quiz.yaml` covers the whole domain.

This draft includes developed readings, private playgrounds and independent graded labs. Static and offline checks pass; live execution remains pending. ATP005 publication remains draft.

## Hands-On Coverage

See the root README for the lab list. All labs and playgrounds are UNTESTED (static checks only).
