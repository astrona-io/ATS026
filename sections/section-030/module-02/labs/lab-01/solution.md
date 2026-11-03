---
draft: true
exam_objectives:
- Use ClusterIP, NodePort, LoadBalancer service types and endpoints
---
# Headless Service, ExternalName And Session Affinity Solution

The three tasks are independent, so you can do them in any order. Check each one before you go on.

## Task 1: the headless Service

A headless Service has `clusterIP: None`. The cluster DNS server then returns the addresses of the ready Pods instead of one virtual address.

Save this as `service-probe-pods.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: probe-pods
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
kubectl apply -f service-probe-pods.yaml
```

Then check the result. The lookup must show three addresses, and `astrona submit -c .` gives feedback on this step:

```sh
kubectl -n starfleet get pods -l app=probe -o wide
kubectl -n starfleet exec deploy/shuttle -- nslookup probe-pods.starfleet.svc.cluster.local
```

## Task 2: the ExternalName Service

An ExternalName Service has no selector and no ClusterIP. The cluster DNS server answers with a CNAME record that points to the name in `externalName`.

Save this as `service-ledger-externalname.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: ledger
  namespace: starfleet
spec:
  type: ExternalName
  externalName: ledger.outpost.svc.cluster.local
```

Apply it:

```sh
kubectl apply -f service-ledger-externalname.yaml
```

Then check the result:

```sh
kubectl -n starfleet exec deploy/shuttle -- wget -q -T 3 -O- http://ledger/
```

## Task 3: session affinity

Session affinity is a field of the existing Service. Patch it in place so that the ClusterIP stays the same.

```sh
kubectl -n starfleet patch service probe --type merge -p '{"spec":{"sessionAffinity":"ClientIP","sessionAffinityConfig":{"clientIP":{"timeoutSeconds":600}}}}'
```

Then check the result. Run the request several times. The `hostname` field in the answer must stay the same:

```sh
kubectl -n starfleet get service probe -o jsonpath='{.spec.sessionAffinity}{"\n"}'
kubectl -n starfleet exec deploy/shuttle -- wget -q -T 3 -O- http://probe/
```
