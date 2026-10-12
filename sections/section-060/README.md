---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Understand and use CoreDNS

A Pod resolves public names but not a Service name, while another Pod cannot reach the resolver at all. These symptoms point to different DNS boundaries.

The explanations identify the responsible components, compare intended and observed state, and work through the decisions needed to preserve the requirement. Read the worked examples as reasoning about a proposed system; no environment is started by this section.

Each module begins with its goals and ends with a summary. Reusable YAML knowledge checks follow the section summary and are registered separately for future presentation.

## Learning Outcomes

- Explain Pod resolver settings and namespace search context.
- Identify Corefile and plugin responsibilities.
- Distinguish cluster lookup from upstream forwarding.
- Diagnose resolver endpoints, permissions and network dependencies.
