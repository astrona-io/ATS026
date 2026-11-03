---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Network Policies Capstone Solution

The work has three parts: isolate `outpost`, give `drifter` the two egress rules it needs, and narrow the ingress of `scout`.

## 1. Deny everything in outpost

Save this as `default-deny-all.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: outpost
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
```

Apply it:

```sh
kubectl apply -f default-deny-all.yaml
```

From now on `drifter` cannot even resolve names, because DNS is egress traffic.

## 2. Allow DNS and scout for drifter

The first rule selects the CoreDNS Pods by namespace and label in one entry. The second rule selects `scout` the same way, with its Pod port 9898, because the policy sees the Pod address after the Service address is replaced. Save this as `networkpolicy-drifter-egress.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: drifter-egress
  namespace: outpost
spec:
  podSelector:
    matchLabels:
      app: drifter
  policyTypes:
    - Egress
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: kube-system
          podSelector:
            matchLabels:
              k8s-app: kube-dns
      ports:
        - protocol: UDP
          port: 53
        - protocol: TCP
          port: 53
    - to:
        - namespaceSelector:
            matchLabels:
              kubernetes.io/metadata.name: starfleet
          podSelector:
            matchLabels:
              app: scout
      ports:
        - protocol: TCP
          port: 9898
```

Apply it:

```sh
kubectl apply -f networkpolicy-drifter-egress.yaml
```

## 3. Narrow the ingress of scout

Two separate entries in `from` are alternatives. The first admits `shuttle` from the same namespace. The second admits `drifter` from `outpost`, with namespace and Pod selector in one entry. Save this as `networkpolicy-scout-ingress.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: scout-ingress
  namespace: starfleet
spec:
  podSelector:
    matchLabels:
      app: scout
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: shuttle
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
kubectl apply -f networkpolicy-scout-ingress.yaml
```

## 4. Test

```sh
kubectl -n outpost exec deploy/drifter -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' http://scout.starfleet.svc/
kubectl -n outpost exec deploy/drifter -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' http://probe.starfleet.svc/
kubectl -n depot exec deploy/visitor -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' http://scout.starfleet.svc/
kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' http://scout.starfleet.svc/
```

The first and last return 200. The second and third print `000` after the timeout.

## 5. Submit

```sh
astrona submit -c .
```
