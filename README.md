# Services & Networking (ATS026)

Certified Kubernetes Administrator (CKA): Services & Networking, worth 20% of the official curriculum. This course belongs to ATP005.

Each section has two modules, each with reading parts, an ungraded playground and graded labs, followed by a section capstone lab and a knowledge-check quiz. A final domain quiz closes the course. Technical content remains draft.

## Course Outline

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

## Hands-On Coverage

The course has 12 module playgrounds, 22 graded labs (including 6 section capstones) and 6 section quizzes plus `sections/final-domain-quiz.yaml`. All environments are UNTESTED: static checks only (configuration validation, shell and YAML syntax). Live execution is pending.

| Section | Lab | Difficulty |
| --- | --- | --- |
| 010 | Trace DNS To A Service Address | intermediate |
| 010 | Repair Pods That Cannot Be Reached | intermediate |
| 010 | Understand Connectivity Between Pods Capstone | advanced |
| 020 | Allow One Peer And Deny Another | intermediate |
| 020 | Allow DNS And One Application Dependency | intermediate |
| 020 | Isolate A Namespace With Network Policies | intermediate |
| 020 | Repair A Network Policy | intermediate |
| 020 | Network Policies Capstone | advanced |
| 030 | Repair A Service Selector | intermediate |
| 030 | Reach A Service Through Its NodePort | intermediate |
| 030 | Headless Service, ExternalName And Session Affinity | intermediate |
| 030 | Services And Endpoints Capstone | advanced |
| 040 | Attach An HTTPRoute To A Gateway | intermediate |
| 040 | Route, Split And Rewrite Traffic With HTTPRoute | intermediate |
| 040 | Repair Gateway Routes Across Namespaces | advanced |
| 050 | Route A Matching Host Through Ingress | intermediate |
| 050 | Verify TLS Termination And Server Identity | intermediate |
| 050 | Route With The Default Class, Path Types And A Default Backend | intermediate |
| 050 | Publish An Application Through An Ingress With TLS | advanced |
| 060 | Restore A Broken CoreDNS Configuration | intermediate |
| 060 | Forward A Stub Domain And Tune Pod DNS | intermediate |
| 060 | CoreDNS Capstone: Headless Records, Rewrite, Own Resolver And Scale | advanced |

The [curriculum map](CURRICULUM.md) records objective coverage and [sources](SOURCES.md) support author review.
