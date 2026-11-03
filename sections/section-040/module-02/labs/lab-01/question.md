---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Route, Split And Rewrite Traffic With HTTPRoute

The `starfleet` namespace has a Gateway named `edge` (class `eg`, HTTP listener on port 80, routes from the same namespace). It also has three backends. The Service `scout-v1` returns the message `v1` and the Service `scout-v2` returns the message `v2`. The Service `echo` returns a description of every request it receives and accepts the path `/anything` and any path below it. The `shuttle` Pod is a client with `curl`.

## Tasks

Create one `HTTPRoute` named `scout` in `starfleet`, attached to the Gateway `edge`, for the host name `scout.local`, with these behaviours:

1. A request to any path goes to `scout-v1` (port 80) by default.
2. A request that has the header `x-canary` with the exact value `true` goes to `scout-v2` (port 80) instead.
3. A request for the path prefix `/legacy` gets an HTTP 301 redirect to the path `/`.
4. A request for the path prefix `/echo` goes to `echo` (port 80). The prefix `/echo` must be replaced by `/anything` before the request reaches the backend, so `/echo/probe` arrives as `/anything/probe`. The request must also carry the header `x-route` with the value `scout`.
5. The route must be accepted by the Gateway and all its backend references must resolve.

## Constraints

- Change only the HTTPRoute. Do not edit the Gateway, the Deployments or the Services.
- Use the Service port 80 in every `backendRefs` entry.

Check your work with `astrona submit -c .`.
