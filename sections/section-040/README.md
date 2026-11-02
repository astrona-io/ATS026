---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Use the Gateway API to manage Ingress traffic

An HTTPRoute exists, but the Gateway listener does not allow its namespace to attach. Resource creation succeeded while the intended relationship was rejected.

The explanations identify the responsible components, compare intended and observed state, and work through the decisions needed to preserve the requirement. Read the worked examples as reasoning about a proposed system; no environment is started by this section.

Each module begins with its goals and ends with a summary. Reusable YAML knowledge checks follow the section summary and are registered separately for future presentation.

## Learning Outcomes

- Distinguish infrastructure class, listener and route roles.
- Evaluate namespace attachment and hostname relationships.
- Explain backend references and ReferenceGrant permission.
- Interpret acceptance, programming and reference conditions.
