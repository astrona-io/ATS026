---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Starting Environment

Bootstrap saves the original Corefile, introduces an invalid directive and restarts CoreDNS. The application listeners remain healthy while name resolution fails.

Trace failed name resolution to a Corefile syntax error and restore the saved configuration.
