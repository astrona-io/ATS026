---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Routes And Status Conditions

A Gateway with no route answers every request with an error. A route that the controller refuses does the same, and `kubectl apply` shows no difference between the two. The only reliable evidence is the status that the controller writes. This part creates a working HTTPRoute, sends requests through the Gateway, and then breaks the route in two ways to show which condition reports each failure.

## Create a route and send a request

The playground already has the Gateway `edge` in the `starfleet` namespace with an HTTP listener on port 80 that allows routes from its own namespace. It also has the `probe` Service on port 80, which forwards to a container that listens on port 8080. An HTTPRoute must name the Service port (80), not the container port.

<!-- astrona:playground:renew -->

Save this as `httproute-probe.yaml`:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: probe-route
  namespace: starfleet
spec:
  parentRefs:
    - name: edge
  hostnames:
    - probe.local
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
      backendRefs:
        - name: probe
          port: 80
```

Apply it:

```sh
kubectl apply -f httproute-probe.yaml
```

Then read the status that the controller wrote:

```sh
kubectl -n starfleet get httproute probe-route -o jsonpath='{range .status.parents[0].conditions[*]}{.type}={.status} ({.reason}){"\n"}{end}'
```

The output lists the conditions of the route for the parent `edge`. `Accepted=True` says the Gateway and its listener allow this route. `ResolvedRefs=True` says every backend reference points to a real Service and port. Both must be `True` before the route carries traffic. The conditions can take a few seconds to appear after the apply, so run the command again if the list is empty.

The route has no port for the client to use, so the client sends the request to the Gateway address. Read the address and request the host `probe.local` from the `shuttle` Pod:

```sh
GATEWAY=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}')
kubectl -n starfleet exec shuttle -- wget -qO- --header 'Host: probe.local' "http://$GATEWAY/"
```

The Envoy proxy chooses a route from the `Host` header, so `--header 'Host: probe.local'` is what selects `probe-route`. The answer comes from one of the two `probe` Pods and contains `version=v1`. Request the same address with `--header 'Host: other.local'` and the proxy returns an HTTP 404 status, because no route matches that host name. This is the Gateway API answer to a request that matches nothing, and it differs from a timeout, which means the request never reached the proxy.

## Match rules inside a route

A route has a list of `rules`. Each rule has `matches` and `backendRefs`. A request matches a rule when it satisfies at least one of the entries in `matches`, and all the conditions inside that one entry. A `path` match has a `type` and a `value`. The type `PathPrefix` with value `/` matches every path. The type `Exact` matches only one path. When several rules match, the Gateway API ranks them: an exact path beats a longer prefix, a longer prefix beats a shorter one, and the rule that appears first in the oldest route wins a tie.

The `hostnames` list is checked before the rules. If the listener also has a `hostname`, only the host names that overlap with it stay in the route. A route with no overlap is not accepted, and the status says so.

## A route in a namespace the listener does not allow

The `outpost` namespace has no permission on the `edge` listener, because the listener allows only its own namespace. Save this as `httproute-outpost.yaml`:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: drifter-route
  namespace: outpost
spec:
  parentRefs:
    - name: edge
      namespace: starfleet
  hostnames:
    - drifter.local
  rules:
    - backendRefs:
        - name: drifter
          port: 80
```

Apply it and read the conditions:

```sh
kubectl apply -f httproute-outpost.yaml
kubectl -n outpost get httproute drifter-route -o jsonpath='{range .status.parents[0].conditions[*]}{.type}={.status} ({.reason}){"\n"}{end}'
```

The Kubernetes API server accepts the object. The controller then reports `Accepted=False` with the reason `NotAllowedByListeners`. The reason names the cause exactly: the listener refuses routes from this namespace. The `drifter` Service does not exist in `outpost`, but the controller does not reach that check, because the route was refused first. You can confirm the count on the Gateway:

```sh
kubectl -n starfleet get gateway edge -o jsonpath='{.status.listeners[0].attachedRoutes}{"\n"}'
```

The number is `1`: only `probe-route` attached. Fixing the problem means a change on the Gateway side, where the owner of the listener decides which namespaces may attach.

## A backend that does not exist

Edit the route to point at a Service that is not there. Save this as `httproute-probe-broken.yaml`:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: probe-route
  namespace: starfleet
spec:
  parentRefs:
    - name: edge
  hostnames:
    - probe.local
  rules:
    - backendRefs:
        - name: probes
          port: 80
```

Apply it, read the conditions, and send the same request as before:

```sh
kubectl apply -f httproute-probe-broken.yaml
kubectl -n starfleet get httproute probe-route -o jsonpath='{range .status.parents[0].conditions[*]}{.type}={.status} ({.reason}){"\n"}{end}'
kubectl -n starfleet exec shuttle -- wget -S -qO- --header 'Host: probe.local' "http://$GATEWAY/"
```

Now `Accepted` stays `True`, because the listener allows the route, but `ResolvedRefs` is `False` with the reason `BackendNotFound`. The request gets an HTTP error status from the proxy, because the rule has no valid backend. Two different conditions pointed at two different owners: `Accepted` is about the Gateway and its listeners, and `ResolvedRefs` is about the Services that the route names. Apply `httproute-probe.yaml` again to restore the working route.

## What you know now

A working route has `Accepted=True` and `ResolvedRefs=True`. A request is matched by its `Host` header and then by the rule matches, and a request that matches nothing gets a 404 answer from the proxy. A refused attachment shows as `Accepted=False` and an unresolved backend shows as `ResolvedRefs=False`. What remains open is how to change the matching itself: headers, weights and filters, and how to let a route use a Service in another namespace.

## Common pitfalls

> [!WARNING]
> Do not read only the first condition. A route can be `Accepted=True` and still fail on `ResolvedRefs`. The backend port in `backendRefs` is the Service port, not the container port. A 404 from the proxy means no route matched the `Host` header; check `hostnames` before you change the backend.
