---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Know how to use Ingress controllers and Ingress resources

A client requests `probe.local`, and Traefik chooses an Ingress route before forwarding to the `probe` Service. The Ingress object declares matching rules; the controller implements them. A rule stored without an active controller cannot provide the same routing behavior.

The explanations identify the responsible components, compare intended and observed state, and work through the decisions needed to preserve the requirement. Read the worked examples as reasoning about a proposed system; no environment is started by this section.

Each module begins with its goals and ends with a summary. Reusable YAML knowledge checks follow the section summary and are registered separately for future presentation.

## Learning Outcomes

- Identify controller class and entry-point requirements.
- Compare host and path matching rules.
- Trace Service backend ports and TLS behavior.
- Distinguish route fallback from application failure.
