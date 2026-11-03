---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Isolate A Namespace With Network Policies Solution

Build the structure in three policies: isolate everything, open the namespace to itself, then add one narrow peer.

## 1. Check the starting point

```sh
kubectl -n outpost exec deploy/drifter -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' http://bridge.starfleet.svc/
```

The request returns 200, because no policy selects any Pod.

## 2. Isolate every Pod for ingress

Save this as `default-deny-ingress.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: starfleet
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```

Apply it:

```sh
kubectl apply -f default-deny-ingress.yaml
```

## 3. Open the namespace to itself

Save this as `allow-same-namespace.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-same-namespace
  namespace: starfleet
spec:
  podSelector: {}
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector: {}
```

Apply it:

```sh
kubectl apply -f allow-same-namespace.yaml
```

## 4. Admit drifter to scout

The rule names the namespace and the Pod label in one `from` entry, so both must match. The port is the container port of `scout`, 9898, because the policy sees the Pod address after the Service address is replaced. Save this as `allow-drifter-to-scout.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-drifter-to-scout
  namespace: starfleet
spec:
  podSelector:
    matchLabels:
      app: scout
  policyTypes:
    - Ingress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: outpost
          podSelector:
            matchLabels:
              app: drifter
      ports:
        - protocol: TCP
          port: 9898
```

Apply it:

```sh
kubectl apply -f allow-drifter-to-scout.yaml
```

## 5. Test both directions

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' http://bridge.starfleet.svc/
kubectl -n outpost exec deploy/drifter -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' http://scout.starfleet.svc/
kubectl -n outpost exec deploy/drifter -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' http://bridge.starfleet.svc/
```

The first two return 200. The third times out and prints `000`.

## 6. Submit

```sh
astrona submit -c .
```
