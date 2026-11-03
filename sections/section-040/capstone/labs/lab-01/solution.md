---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Solution: Repair Gateway Routes Across Namespaces

Start with the status of each route. The status tells you the cause, and the cause tells you who must change what.

## Step 1: Read the conditions

Read the conditions of the three routes:

```sh
kubectl -n outpost get httproute drifter -o jsonpath='{range .status.parents[*].conditions[*]}{.type}={.status} ({.reason}){"\n"}{end}'
kubectl -n starfleet get httproute stock -o jsonpath='{range .status.parents[*].conditions[*]}{.type}={.status} ({.reason}){"\n"}{end}'
kubectl -n starfleet get httproute scout -o jsonpath='{range .status.parents[*].conditions[*]}{.type}={.status} ({.reason}){"\n"}{end}'
```

The route `drifter` reports `Accepted=False` with the reason `NotAllowedByListeners`. The route `stock` is accepted and reports `ResolvedRefs=False` with the reason `RefNotPermitted`. The route `scout` reports no fault, because its fault is in the weights, not in the status.

## Step 2: Allow the namespace outpost

The listener accepts routes from namespaces with the label `gateway-access=allowed`. The namespace `outpost` does not have it. Label the namespace instead of changing the Gateway:

```sh
kubectl label namespace outpost gateway-access=allowed
```

The controller reads the route again within a few seconds, and `Accepted` becomes `True`.

## Step 3: Grant the reference to stock

The route `stock` may attach, but it may not use a Service in `catalog`. The permission is a `ReferenceGrant` in the namespace `catalog`. Save this as `referencegrant-stock.yaml`:

```yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: ReferenceGrant
metadata:
  name: allow-starfleet-routes
  namespace: catalog
spec:
  from:
    - group: gateway.networking.k8s.io
      kind: HTTPRoute
      namespace: starfleet
  to:
    - group: ""
      kind: Service
      name: stock
```

Apply it:

```sh
kubectl apply -f referencegrant-stock.yaml
```

The `name` field limits the grant to one Service. Without it, the grant covers every Service in `catalog`.

## Step 4: Repair the route scout

The route has one rule with the weights reversed and no header match. Save this as `httproute-scout.yaml`:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: scout
  namespace: starfleet
spec:
  parentRefs:
    - name: edge
  hostnames:
    - scout.local
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
          headers:
            - type: Exact
              name: x-canary
              value: "true"
      backendRefs:
        - name: scout-v2
          port: 80
    - matches:
        - path:
            type: PathPrefix
            value: /
      backendRefs:
        - name: scout-v1
          port: 80
          weight: 90
        - name: scout-v2
          port: 80
          weight: 10
```

Apply it:

```sh
kubectl apply -f httproute-scout.yaml
```

The first rule has a header test and the second has none, so the first rule wins for requests that carry the header, whatever the order in the list.

## Step 5: Check the result

Read the Gateway address and send one request to each host name:

```sh
GATEWAY=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}')
kubectl -n starfleet exec deploy/shuttle -- curl -s -H "Host: drifter.local" "http://$GATEWAY/"
kubectl -n starfleet exec deploy/shuttle -- curl -s -H "Host: stock.local" "http://$GATEWAY/"
kubectl -n starfleet exec deploy/shuttle -- curl -s -H "Host: scout.local" -H "x-canary: true" "http://$GATEWAY/"
```

The first answer contains the message `drifter`, the second contains `stock` and the third contains `v2`. Then run `astrona submit -c .`.
