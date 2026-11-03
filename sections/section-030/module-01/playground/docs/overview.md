---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Overview: Service Types And Endpoint Relationships (Playground)

This is a **playground**, not a lab. It starts a fresh cluster and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, `astrona destroy`, start over.

## What's in the box

The namespaces `starfleet` and `outpost`. In `starfleet`, the Deployment `probe` runs two replicas of a Python web server on port 8080 (container port name `http`), with a readiness probe on `/ready`. The Service `probe` has a selector that matches no Pod. The Pod `shuttle` in `starfleet` and the Pod `drifter` in `outpost` are client Pods with `wget`. The cluster has one control plane node and one worker node.

## Practice tasks

- Compare the selector of the Service `probe` with the labels of the Pods and find the label that does not match. Repair the Service with `kubectl patch` or `kubectl apply`.
- Read the EndpointSlices of `probe` before and after the repair.
- Request `http://probe/` from `shuttle`, and from `drifter` with `http://probe.starfleet.svc/`.
- Change the Service to type `NodePort`, read the allocated port with `kubectl get service probe`, and request a node address on that port from `shuttle`.
- Set the `targetPort` to a port where nothing listens and compare the failure with the earlier one.
- Create the file `/tmp/not-ready` in one `probe` Pod and watch the `READY` column and the EndpointSlice change. Remove the file again.
- Change the Service type to `LoadBalancer` and read the `EXTERNAL-IP` column.
