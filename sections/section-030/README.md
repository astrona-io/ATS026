---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Use ClusterIP, NodePort, LoadBalancer service types and endpoints

The `probe` Service exposes port 80 while its selected application listens on port 8080. These ports describe two sides of forwarding. Correct labels cannot compensate for a target port that points to the wrong listener.

The explanations identify the responsible components, compare intended and observed state, and work through the decisions needed to preserve the requirement. Read the worked examples as reasoning about a proposed system; no environment is started by this section.

Each module begins with its goals and ends with a summary. Reusable YAML knowledge checks follow the section summary and are registered separately for future presentation.

## Learning Outcomes

- Compare ClusterIP, NodePort and LoadBalancer responsibilities.
- Trace Service and target port mapping.
- Explain selected ready endpoints.
- Evaluate external infrastructure and source-path assumptions.
