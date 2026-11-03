---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Hosts, Path Types And The Default Backend

After the class sends a request to the controller, the controller must pick one rule out of all Ingresses of that class. A wrong guess here sends traffic to the wrong Service or to no Service. This chapter shows the exact matching rules of the Ingress API, the order in which they apply and the points where the API leaves the decision to the controller.

## Host matching

A rule has an optional `host` field. A rule with a host matches only requests whose HTTP Host header equals that value. The Host header is a request header that carries the name the client asked for. A rule without a host matches every host.

A host can start with a wildcard label, for example `*.fleet.local`. A wildcard matches exactly one DNS label in front of the suffix. The Host header `a.fleet.local` matches. The headers `a.b.fleet.local` and `fleet.local` do not match, because the first has two labels in front of the suffix and the second has none. A rule with a precise host is not replaced by a wildcard rule; both can exist.

DNS and host matching are separate steps. DNS turns a name into the address of the controller. The Host header then selects the rule. A test that sends a request to the controller address without the right Host header tests nothing about the rule, which is why the examples set the header with `curl -H`.

## Path types

Every path needs a `pathType`, and a path without it fails validation. There are three types.

`Exact` matches the whole request path and is case sensitive. The path `/status` matches `/status` and does not match `/status/`.

`Prefix` compares path elements, the parts between slashes. The path `/app` matches `/app`, `/app/` and `/app/home`. It does not match `/apple`, because `apple` is a different element than `app`. A trailing slash in the rule is ignored, and the path `/` matches every path.

`ImplementationSpecific` leaves the meaning to the controller. A controller can treat it like `Prefix`, like `Exact` or as its own mode. Traefik uses its router rule type for it, which is a prefix match by default and can change with an annotation. Use `Prefix` or `Exact` when the behavior must be portable.

## Precedence

Several paths of one host can match one request. The API defines the order: the longest matching path wins. If two paths have the same length, the `Exact` path wins over the `Prefix` path. For the request `/app/admin/users` and the rules `/app` and `/app/admin`, the rule `/app/admin` wins, because it is longer.

The order of the paths in the YAML does not matter. The Ingress objects of one class are also combined, so two Ingresses can compete for the same host and path. The result of such a conflict depends on the controller, so avoid it.

## The default backend

A request that matches no rule of any Ingress needs an answer. The field `spec.defaultBackend` names a Service that receives such requests. An Ingress with no rules must set it. If no default backend exists, the controller decides what to answer, and most controllers answer with their own 404 response.

A default backend is a controller feature as much as an API field. In Traefik, an Ingress with `spec.defaultBackend` creates a catch-all route that matches every host. That route can capture requests meant for other Ingresses, so the Traefik documentation advises a low priority for it.

## Settings that belong to one controller

Controllers add behavior through annotations or their own resources. These settings are not part of the Ingress API. For example, a request for `/app/home` reaches the backend as `/app/home`, because the Ingress API does not rewrite paths. ingress-nginx uses the annotation `nginx.ingress.kubernetes.io/rewrite-target` for that. Traefik uses a Middleware object that an Ingress names with the annotation `traefik.ingress.kubernetes.io/router.middlewares`.

An annotation for a controller that is not installed is ignored without an error. Test every controller setting on the real controller.

## Try it: paths, precedence and the default backend

The next Ingress combines two `Prefix` paths of different length, one `Exact` path and a default backend, all on the host `paths.local`. Each backend answers with its own name and the path it received.

<!-- astrona:playground:renew -->

Save this as `ingress-paths-demo.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: paths-demo
  namespace: starfleet
spec:
  ingressClassName: traefik
  defaultBackend:
    service:
      name: fallback
      port:
        number: 80
  rules:
  - host: paths.local
    http:
      paths:
      - path: /app
        pathType: Prefix
        backend:
          service:
            name: scout
            port:
              number: 80
      - path: /app/admin
        pathType: Prefix
        backend:
          service:
            name: probe
            port:
              number: 80
      - path: /status
        pathType: Exact
        backend:
          service:
            name: bridge
            port:
              number: 80
```

Apply it:

```sh
kubectl apply -f ingress-paths-demo.yaml
```

Then send four requests. The first helper line saves the typing:

```sh
through_traefik() { kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -H "Host: $1" "http://traefik.ingress-system.svc$2"; }
through_traefik paths.local /app/home
through_traefik paths.local /app/admin/users
through_traefik paths.local /status
through_traefik paths.local /apple
```

If a request returns Traefik's own `404 page not found`, wait a few seconds for the controller to load the Ingress and send it again. The first request reaches `scout`, because `/app` is the only prefix of `/app/home`. The second reaches `probe`, because `/app/admin` is longer than `/app`. The third reaches `bridge` through the `Exact` rule. The fourth shares only text with `/app`, so no path matches and the default backend `fallback` answers.

Two more requests show the `Exact` limit and the host rule:

```sh
through_traefik paths.local /status/
through_traefik other.local /app/home
```

By the API rules, `/status/` does not match the `Exact` path, so it reaches `fallback`. The second request has a host that no rule names, and in this Traefik instance the default backend also catches it. Each answer prints the path it received, which confirms that the controller forwarded the path without a rewrite.

Read the controller log after the requests. It shows the configuration that Traefik loaded and any errors it found in the Ingress objects:

```sh
kubectl -n ingress-system logs deployment/traefik --tail=30
kubectl -n starfleet get ingress paths-demo
```

The `ADDRESS` column of the Ingress can stay empty here. The controller writes an address into the Ingress status only when it is started with an option for that, and a missing address does not mean that routing fails. The status is a clue, not a test.

You can now predict the rule that handles a request from its host, its path and the path types, and you know which parts of that decision the API defines and which parts the controller owns.

## Common pitfalls

> [!WARNING]
> A `Prefix` path matches path elements, not text, so `/app` does not match `/apple`. An `Exact` path does not match a trailing slash. `ImplementationSpecific` is not portable. A default backend can answer requests for other hosts, and an empty `ADDRESS` column is not proof of a fault.
