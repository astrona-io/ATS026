---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Define and enforce Network Policies

A rule should allow only Pods labelled `app: shuttle` inside a selected namespace. Placing both selectors in one peer requires both matches. Splitting them into separate peers changes the condition into alternatives and can widen access.

The explanations identify the responsible components, compare intended and observed state, and work through the decisions needed to preserve the requirement. Read the worked examples as reasoning about a proposed system; no environment is started by this section.

Each module begins with its goals and ends with a summary. Reusable YAML knowledge checks follow the section summary and are registered separately for future presentation.

## Learning Outcomes

- Explain directional selection and additive allowances.
- Interpret peer selectors and ports.
- Identify required discovery and backend dependencies.
- Distinguish declaration from demonstrated enforcement.
