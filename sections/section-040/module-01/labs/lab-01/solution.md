---
draft: true
exam_objectives:
- Use the Gateway API to manage Ingress traffic
---
# Attach An HTTPRoute To A Gateway Solution

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-026-lab-040-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-026-lab-040-01-01" || exit 1
node_name="astro-ats-026-lab-040-01-01-control-plane"
worker_name="astro-ats-026-lab-040-01-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Inspect And Explain

The isolated environment has two healthy probe replicas, an internal Service and two client Pods. The required result has not been configured.

Inspect the current objects before changing them:

```sh
kubectl -n starfleet get pods -o wide
kubectl get nodes -o wide
```

Create Gateway probe using class eg and an HTTP listener on port 80 allowing same-namespace routes. Attach HTTPRoute probe for host probe.local, Prefix path / and backend probe port 80. Gateway Programmed and route Accepted and ResolvedRefs conditions must be True. A request through the generated Envoy Service must receive version one with the matching Host header.

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

Apply the scoped correction:

```sh
kubectl apply -f gateway-probe.yaml
```

## Verify The Result

Observe the actual result. A denied request returns a nonzero status when the denial works, so run it separately from a shell sequence that stops on error. Status convergence and a successful request establish different parts of the result.

```sh
kubectl -n starfleet wait --for=condition=Programmed gateway/probe --timeout=240s
```

Connect class, listener, route and backend and inspect controller acceptance. The commands above deliberately target one environment. Keep its remaining components available so an unrelated failure cannot stand in for the required denial or correction. No example command output is presented as evidence of a completed run. A matching field alone does not establish that a process used it or that a controller reconciled it.

After recording your result, remove the independent lab with `astrona destroy ats-026-lab-040-01-01`.

## Common pitfalls

> [!WARNING]
> Confirm the private context and exact node names before a change. Check the stated scope and live result. Do not change unrelated components to hide the original fault.
