---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Services And Endpoints Capstone

The `probe` Deployment in `starfleet` runs three Pods. The Service `probe` in front of them does not work, and the team also needs the application reachable on the node addresses, a name that returns the Pod addresses, and requests that stay on one Pod.

## Tasks

1. Repair the Service `probe` so that `http://probe/` answers HTTP 200 from the `shuttle` Pod and the Service has three ready endpoints. The Service keeps port 80.
2. Make `probe` a NodePort Service with node port 30090. A request from `shuttle` to port 30090 of each node address must answer.
3. Create a headless Service `probe-peers` in `starfleet` that selects the `probe` Pods and exposes port 80 with `targetPort: http`.
4. Turn on ClientIP session affinity for `probe` with a timeout of 300 seconds.

## Constraints

- Repair the Service `probe` in place. Do not delete and recreate it.
- Do not change the Deployments, their labels or their images.

Check your work with `astrona submit -c .`.
