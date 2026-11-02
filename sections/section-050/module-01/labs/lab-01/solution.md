---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Route A Matching Host Through Ingress Solution

Use a host shell with this lab's private kubeconfig. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool. This environment is separate from the ungraded playground.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-026-lab-050-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-026-lab-050-01-01" || exit 1
```

Keep this connection selected throughout the task. Every script supplied by the lab refuses a different context.

## Inspect And Explain

The lab includes a working Traefik Ingress controller and healthy application. The required route has not been created.

Inspect the relevant evidence:

```sh
kubectl -n starfleet get ingress
kubectl -n starfleet get service probe
kubectl -n ingress-system logs deployment/traefik --tail=20
```

An Ingress declares routing rules that an Ingress controller implements. The client must reach that controller and supply the matching host. Requesting the backend directly skips the routing rule. Test both a matching host and an unmatched host through the same listener.


Save this as `ingress-probe.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: probe
  namespace: starfleet
spec:
  ingressClassName: traefik
  rules:
  - host: probe.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: probe
            port:
              number: 80
```

Apply the required change:

```sh
kubectl apply -f ingress-probe.yaml
```

## Verify The Result

Observe the actual result. A denied-request command returns a nonzero status when the denial works. Run denial checks separately from a shell sequence that stops on the first nonzero status.

```sh
kubectl -n starfleet exec deployment/probe -- python -c 'import urllib.request,urllib.error; request=urllib.request.Request('"'"'http://traefik.ingress-system.svc/'"'"',headers={'"'"'Host'"'"':'"'"'probe.local'"'"'}); print(urllib.request.urlopen(request,timeout=5).read().decode())'
kubectl -n starfleet exec deployment/probe -- python -c 'import urllib.request,urllib.error; request=urllib.request.Request('"'"'http://traefik.ingress-system.svc/'"'"',headers={'"'"'Host'"'"':'"'"'unmatched.local'"'"'});
try: urllib.request.urlopen(request,timeout=5); raise RuntimeError('"'"'Unexpected matched route'"'"')
except urllib.error.HTTPError as error: print(error.code)'
```

Create an Ingress `probe` for class `traefik`, host `probe.local`, Prefix path `/` and backend Service `probe` port 80. The request through the controller with the matching Host header must receive version one. An unmatched host must return 404. Preserve the original application and Service.

After recording the result, remove this independent lab with `astrona destroy ats-026-lab-050-01-01`.

## Common pitfalls

> [!WARNING]
> Send the matching Host header to the controller. A direct backend request skips Ingress. Keep class, path type and Service client port consistent, and check an unmatched host.
