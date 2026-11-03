---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Attach An HTTPRoute To A Gateway Solution

The `eg` class already exists, so the work is one Gateway and one HTTPRoute in `starfleet`. The listener accepts routes from its own namespace only, which is the default, and the route names its backend by the Service port.

Save this as `gateway-probe.yaml`:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: probe
  namespace: starfleet
spec:
  gatewayClassName: eg
  listeners:
  - name: http
    protocol: HTTP
    port: 80
    allowedRoutes:
      namespaces:
        from: Same
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: probe
  namespace: starfleet
spec:
  parentRefs:
  - name: probe
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
kubectl apply -f gateway-probe.yaml
```

Then check the result. Wait for the Gateway, read the route conditions and send a request through the Gateway address:

```sh
kubectl -n starfleet wait --for=condition=Programmed gateway/probe --timeout=240s
kubectl -n starfleet get httproute probe -o jsonpath='{range .status.parents[0].conditions[*]}{.type}={.status}{"\n"}{end}'
GATEWAY=$(kubectl -n starfleet get gateway probe -o jsonpath='{.status.addresses[0].value}')
kubectl -n starfleet exec shuttle -- wget -qO- --header 'Host: probe.local' "http://$GATEWAY/"
```

The route shows `Accepted=True` and `ResolvedRefs=True`, and the request returns a line that contains `version=v1`. Submit with `astrona submit -c .`. When you are done, remove the environment with `astrona destroy ats-026-lab-040-01-01`.

## Common pitfalls

> [!WARNING]
> The route and the Gateway must have the same name in `parentRefs`. Use port 80, the Service port, not 8080, the container port. Do not set `from: All` on the listener.
