---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Solution: Route With The Default Class, Path Types And A Default Backend

Work through the steps in order. The order matters: the API server assigns a default class only when it creates an Ingress, so the class must be the default before the Ingress exists.

## Step 1: Make traefik the default class

List the classes and read which controller each one names:

```sh
kubectl get ingressclass
```

Mark `traefik` as the default class with an annotation:

```sh
kubectl annotate ingressclass traefik ingressclass.kubernetes.io/is-default-class=true
```

Check the annotation. Only one class may be the default. If two classes are defaults, the API server refuses to create an Ingress that has no class:

```sh
kubectl get ingressclass traefik -o jsonpath='{.metadata.annotations}'
```

Run `astrona submit -c .` now. The check `default-class` passes.

## Step 2: Create the Ingress without a class

Save this as `ingress-fleet.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: fleet
  namespace: starfleet
spec:
  defaultBackend:
    service:
      name: fallback
      port:
        number: 80
  rules:
  - host: fleet.local
    http:
      paths:
      - path: /scout
        pathType: Prefix
        backend:
          service:
            name: scout
            port:
              number: 80
      - path: /probe
        pathType: Prefix
        backend:
          service:
            name: probe
            port:
              number: 80
      - path: /bridge
        pathType: Exact
        backend:
          service:
            name: bridge
            port:
              number: 80
```

Apply it:

```sh
kubectl apply -f ingress-fleet.yaml
```

The manifest has no `ingressClassName`. The default-class admission step of the API server filled it in when it created the object. Read the stored value:

```sh
kubectl -n starfleet get ingress fleet -o jsonpath='{.spec.ingressClassName}'
```

If the Ingress already existed without a class before you made `traefik` the default, it keeps `<none>`. Delete it with `kubectl -n starfleet delete ingress fleet` and apply the file again.

## Step 3: Test the routes

Send requests through the controller from `shuttle`:

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -H 'Host: fleet.local' http://traefik.ingress-system.svc/scout/info
kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -H 'Host: fleet.local' http://traefik.ingress-system.svc/bridge
kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -H 'Host: fleet.local' http://traefik.ingress-system.svc/bridge/extra
```

Each backend answers with its own name, the host and the path it received. The first request reaches `scout` and the second reaches `bridge`. The third does not match the `Exact` rule, so the default backend `fallback` answers. If a response is a `404 page not found` from Traefik, wait a few seconds for the controller to load the Ingress and repeat the request.

Run `astrona submit -c .` again. All checks pass.

## Why it works

The class `traefik` names the controller `traefik.io/ingress-controller`. The annotation makes the API server copy `traefik` into every new Ingress that has no class. Traefik handles Ingresses of its class. Longest-path and exact-path rules decide among the three paths, and `spec.defaultBackend` answers every request that no path matches.
