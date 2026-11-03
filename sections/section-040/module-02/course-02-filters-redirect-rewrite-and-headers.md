---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Filters: Redirect, Rewrite And Header Changes

Matches decide which rule serves a request. Filters decide what the Gateway does to the request or the response while it passes through. An old path may need a redirect to a new one. An application may expect the path `/anything` while clients call `/echo`. A backend may need an extra header that the client never sends. This part shows the three filters that cover these cases and the rules about when they run.

## What a filter is

A filter is an entry in the `filters` list of a rule. It runs after the controller has chosen the rule and before the proxy sends the request to the backend. The proxy (Envoy in the playground) does the work. The controller only turns the filter into proxy configuration.

Each filter has a `type` and one field with the settings for that type. The three used here are:

- `RequestRedirect` stops the request at the Gateway and sends an HTTP redirect response to the client. The request never reaches a backend, so a rule with this filter has no `backendRefs`.
- `URLRewrite` changes the host name or the path of the request. The client does not see the change, because the proxy rewrites the request on its way to the backend.
- `RequestHeaderModifier` sets, adds or removes request headers before the request goes to the backend.

A rule can hold several filters, and they run in the order of the list. The core filter types are the same for every controller that implements the Gateway API. Other types exist as extensions, and a controller reports a filter it does not support through the `Accepted` or `ResolvedRefs` condition of the route.

## Redirect an old path

The old path `/legacy` must send clients to `/`. The `RequestRedirect` filter takes a `statusCode`, and the allowed codes are 301 (moved permanently) and 302 (found). It also takes a `path` with a replacement type. `ReplaceFullPath` replaces the entire path with the given value.

<!-- astrona:playground:renew -->

Save this as `httproute-filters.yaml`. The file holds one route with all the rules of this part, and the next sections explain the second and third rule:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: filters
  namespace: starfleet
spec:
  parentRefs:
    - name: edge
  hostnames:
    - filters.local
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /legacy
      filters:
        - type: RequestRedirect
          requestRedirect:
            statusCode: 301
            path:
              type: ReplaceFullPath
              replaceFullPath: /
    - matches:
        - path:
            type: PathPrefix
            value: /echo
      filters:
        - type: URLRewrite
          urlRewrite:
            path:
              type: ReplacePrefixMatch
              replacePrefixMatch: /anything
        - type: RequestHeaderModifier
          requestHeaderModifier:
            set:
              - name: x-route
                value: filters
      backendRefs:
        - name: echo
          port: 80
    - backendRefs:
        - name: scout-v1
          port: 80
```

Apply it and read the Gateway address:

```sh
kubectl apply -f httproute-filters.yaml
GATEWAY=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}')
```

Ask for `/legacy/old` and print the response headers with `-i`. The client does not follow the redirect unless you add `-L`, so you see the redirect response itself:

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -si -H "Host: filters.local" "http://$GATEWAY/legacy/old"
```

The status line shows 301 and a `location` header with the new address. The path in that header is `/`, because `ReplaceFullPath` replaced the whole path, including the part after `/legacy`. The proxy answered the request by itself. No Pod received it.

## Rewrite the path before the backend

A redirect tells the client to ask again. A rewrite changes the request quietly. The `URLRewrite` filter with the type `ReplacePrefixMatch` replaces the part of the path that the rule's `PathPrefix` matched. In the second rule the matched prefix is `/echo` and the replacement is `/anything`, so `/echo/probe` becomes `/anything/probe`.

The `echo` Service runs a small HTTP server that answers every request below `/anything` with a JSON description of the request it received: the path, the query and the headers. The request reaches the backend only after the proxy applied both filters, so the answer shows the changed request.

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s -H "Host: filters.local" "http://$GATEWAY/echo/probe"
```

Look at the `url` or `path` field of the JSON and at the `headers` object. The path reads `/anything/probe` and the headers contain `X-Route` with the value `filters`. The client asked for `/echo/probe`, and the backend never saw that path.

There is a trap in the replacement type. `ReplacePrefixMatch` works only when the rule has a `PathPrefix` match, and it replaces the matched prefix, not the whole path. `ReplaceFullPath` replaces everything and also works with an `Exact` match. If the rule matched `/echo` and the filter said `ReplaceFullPath: /anything`, then `/echo/probe` would arrive as `/anything`, and the `/probe` part would be lost.

## Change headers

The second filter in the same rule is `RequestHeaderModifier`. It has three lists: `set` replaces a header or creates it, `add` appends a value to an existing header, and `remove` deletes headers by name. The filter above uses `set` to give the backend `x-route: filters`.

The change happens inside the proxy, so a client cannot decide the value. A client that sends its own `x-route: attacker` header still reaches the backend with `x-route: filters`, because `set` replaces the value. Send a request with a header of the same name to see it:

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s -H "Host: filters.local" -H "x-route: attacker" "http://$GATEWAY/echo/probe"
```

The `headers` object in the answer shows the value `filters`. The same filter type exists for responses (`ResponseHeaderModifier`), and it changes the headers that travel back to the client.

The third rule has no matches and one backend. It takes every request that the first two rules did not take, and sends it to `scout-v1`.

## What you know now

A filter changes a request after the controller chose the rule. `RequestRedirect` answers on its own, `URLRewrite` changes the path or host name that the backend sees, and `RequestHeaderModifier` changes headers. The type of replacement decides how much of the path changes. The open question is permission: so far every route, Gateway and Service sat in the same namespace. Next comes what happens when they do not.

## Common pitfalls

> [!WARNING]
> - Adding `backendRefs` to a rule that has a `RequestRedirect` filter. The redirect answers first, so the backends never receive a request.
> - Using `ReplacePrefixMatch` on a rule with an `Exact` path match. It needs a `PathPrefix` match.
> > - Testing a redirect with `curl -L`. The client follows the redirect, and you no longer see the 301 response.
> - Trusting a request header as proof of identity without a `set` filter. A client can send any header.
