# Curriculum Coverage

Exam: Certified Kubernetes Administrator (CKA). Domain: Services & Networking (20%).

The [official objectives](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/) were verified on 2026-10-11. Teaching structure is original; it does not add official exam requirements.

| Section | Official objective | Modules |
| --- | --- | --- |
| 010 | Understand connectivity between Pods | 1 |
| 020 | Define and enforce Network Policies | 1 |
| 030 | Use ClusterIP, NodePort, LoadBalancer service types and endpoints | 1 |
| 040 | Use the Gateway API to manage Ingress traffic | 1 |
| 050 | Know how to use Ingress controllers and Ingress resources | 1 |
| 060 | Understand and use CoreDNS | 1 |

| Section / module | Module | Teaching lessons |
| --- | --- | --- |
| 010 / 01 | Pod Addressing And Communication | Pod Addresses And Network Implementation; DNS And Service Discovery |
| 020 / 01 | Traffic Isolation And Enforcing Implementations | Traffic Isolation And Allowed Peers; NetworkPolicy And Allowed Connections |
| 030 / 01 | Service Types And Endpoint Relationships | Selectors, Ports And Backends; External Entry And Application Routing |
| 040 / 01 | Gateway Classes, Listeners And Routes | Gateway API Roles, Listeners And Attached Routes |
| 050 / 01 | Ingress Selection And Request Diagnosis | Matching Ingress Hosts, Paths And Service Backends; Tracing An External Request To The Application |
| 060 / 01 | CoreDNS Configuration And Resolution Diagnosis | CoreDNS Configuration And Cluster Name Resolution |

The module goals and adaptation sources are recorded in AUTHORING.yaml. Every official objective is covered. Each section starts with an introduction, and each module ends with a summary. YAML banks follow the relevant summary and remain separate from the Markdown manifest.

This is a reading-only draft. No new labs, playgrounds, command output or runtime verification are included. ATP005 publication remains draft.
