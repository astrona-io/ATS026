# Section 020: Define And Enforce Network Policies

Makes the reader able to restrict which Pods may send and receive traffic with NetworkPolicy: isolate a namespace with default-deny policies, admit named peers with namespace and Pod selectors, keep DNS working under an egress policy and find the cause when a policy blocks too much or too little. Every policy depends on a network plugin that enforces it, so the playgrounds and labs use a kind cluster with Calico.

**Curriculum item covered:** Define and enforce Network Policies

---

## What You Will Master

- Explain when a Pod becomes isolated and what isolation means for ingress and egress
- Write ingress rules with Pod selectors, namespace selectors, IP blocks and ports
- Combine selectors in one peer entry and in separate entries and predict the result
- Write egress rules that keep DNS working
- Create default-deny policies for ingress, egress and both
- Predict the union of the rules of several policies that select one Pod
- Use `ipBlock` with `except` and port ranges with `endPort`
- Find the policy that decides a connection by checking endpoints, selectors, labels and the Pod port
- Verify a fix from the allowed side and the denied side
- Explain why a policy has no effect when the network plugin does not enforce it

---

## The Learning Path

### 1. Traffic Isolation And Enforcing Implementations
- **Module reader:** `module-01/course.md`
- **Playground:** `module-01/playground` — kind cluster with Calico, namespaces `starfleet` and `outpost` with the example workloads.
- **Labs:** `module-01/labs/lab-01` (allow one peer and deny another) and `module-01/labs/lab-02` (allow DNS and one application dependency).

### 2. Network Policy Patterns And Troubleshooting
- **Module reader:** `module-02/course.md`
- **Playground:** `module-02/playground` — the same workloads, Calico, and one policy that is wrong on purpose (`probe-ingress`).
- **Labs:** `module-02/labs/lab-01` (isolate a namespace) and `module-02/labs/lab-02` (repair a network policy).

### Capstone
- **Lab:** `capstone/labs/lab-01` — default deny for both directions, DNS egress and a narrow ingress rule across three namespaces.

### Knowledge check
- `quiz.yaml` — 12 single-choice questions.

UNTESTED: playgrounds and labs are checked statically only (configuration validation, shell and YAML syntax). They have not been run.
