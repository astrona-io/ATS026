---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Summary

Traffic policies describe allowed relationships for selected Pods and directions under an enforcing implementation. Combined selectors and separate alternatives have different meanings.

Useful isolation must preserve required dependencies and account for the actual traffic path. Accepted policy objects do not prove enforcement or application authorization, so those boundaries need separate evidence.

You can now calculate declared network allowances and state what their inspection cannot prove. Enforcement verification needs the intended caller and a deliberately disallowed caller, not merely the existence of a policy object.
