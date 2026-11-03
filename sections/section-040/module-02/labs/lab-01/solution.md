---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Route, Split And Rewrite Traffic With HTTPRoute Solution

One HTTPRoute holds four rules. The Gateway API ranks the rules that match a request: a longer path prefix beats a shorter one, and for the same path a rule with a header match beats a rule without one. The header rule and the default rule both use the prefix `/`, so the header rule wins when the header is present. The prefixes `/legacy` and `/echo` are longer than `/`, so they win for their paths.

Save this as `httproute-scout.yaml`:

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
                value: scout
      backendRefs:
        - name: echo
          port: 80
```

Apply it:

```sh
kubectl apply -f httproute-scout.yaml
```

Then check the result. Read the conditions and send four requests from the `shuttle` Pod:

```sh
kubectl -n starfleet get httproute scout -o jsonpath='{range .status.parents[0].conditions[*]}{.type}={.status}{"\n"}{end}'
GATEWAY=$(kubectl -n starfleet get gateway edge -o jsonpath='{.status.addresses[0].value}')
kubectl -n starfleet exec deploy/shuttle -- curl -s -H 'Host: scout.local' "http://$GATEWAY/"
kubectl -n starfleet exec deploy/shuttle -- curl -s -H 'Host: scout.local' -H 'x-canary: true' "http://$GATEWAY/"
kubectl -n starfleet exec deploy/shuttle -- curl -s -o /dev/null -w '%{http_code} %{redirect_url}\n' -H 'Host: scout.local' "http://$GATEWAY/legacy"
kubectl -n starfleet exec deploy/shuttle -- curl -s -H 'Host: scout.local' "http://$GATEWAY/echo/probe"
```

The first request returns the message `v1` and the second returns `v2`. The third prints `301` and a location that ends with `/`. The fourth shows the request as the backend received it, with the path `/anything/probe` and the header `X-Route`. Submit with `astrona submit -c .` and remove the environment with `astrona destroy ats-026-lab-040-02-01`.

## Common pitfalls

> [!WARNING]
> A redirect rule and a rewrite rule cannot be combined in one rule. A rewrite changes the request on its way to the backend, and a redirect sends the answer back to the client. Put the header value in quotes (`"true"`) so YAML keeps it a string.
