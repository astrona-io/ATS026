---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Understand connectivity between Pods

A Pod IP changes when the application is replaced, but the Service still provides the same access point. Pod addressing and Service forwarding are different network responsibilities. Understanding both helps localize a request failure.

The explanations identify the responsible components, compare intended and observed state, and work through the decisions needed to preserve the requirement. Read the worked examples as reasoning about a proposed system; no environment is started by this section.

Each module begins with its goals and ends with a summary. Reusable YAML knowledge checks follow the section summary and are registered separately for future presentation.

## Learning Outcomes

- Explain Pod address and shared-network behavior.
- Identify network implementation responsibilities.
- Distinguish name resolution from destination connectivity.
- Diagnose listener, address and routing assumptions.
