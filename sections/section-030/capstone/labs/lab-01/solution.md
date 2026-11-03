---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Services And Endpoints Capstone Solution

Work from the Pods towards the Service. The faults sit in the selector and the port mapping, and the new settings go into the same Service.

## Find the faults

Compare the selector of the Service with the labels of the Pods, read the EndpointSlices, and read the ports:

```sh
kubectl -n starfleet get service probe -o yaml
kubectl -n starfleet get pods --show-labels
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe
```

The selector asks for `tier: backend`, but the Pods carry `tier: web`, so the slice is empty. The `targetPort` is 8080, but the container port named `http` is 9898.

## Repair and expose the Service

Save this as `service-probe.yaml`. It sets the selector, the target port, the type, the node port and the affinity in one object:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: probe
  namespace: starfleet
spec:
  type: NodePort
  selector:
    app: probe
    tier: web
  sessionAffinity: ClientIP
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 300
  ports:
  - name: http
    port: 80
    targetPort: http
    nodePort: 30090
```

Apply it:

```sh
kubectl apply -f service-probe.yaml
```

Then check the result. Use an `INTERNAL-IP` from the node list in place of `<NODE_IP>`:

```sh
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe
kubectl -n starfleet exec deploy/shuttle -- wget -q -T 3 -O- http://probe/
kubectl get nodes -o wide
kubectl -n starfleet exec deploy/shuttle -- wget -q -T 3 -O- http://<NODE_IP>:30090/
```

## Add the headless Service

Save this as `service-probe-peers.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: probe-peers
  namespace: starfleet
spec:
  clusterIP: None
  selector:
    app: probe
  ports:
  - name: http
    port: 80
    targetPort: http
```

Apply it:

```sh
kubectl apply -f service-probe-peers.yaml
```

Then check that the name returns the three Pod addresses:

```sh
kubectl -n starfleet exec deploy/shuttle -- nslookup probe-peers.starfleet.svc.cluster.local
kubectl -n starfleet get pods -l app=probe -o wide
```

Run `astrona submit -c .` for feedback on each requirement.
