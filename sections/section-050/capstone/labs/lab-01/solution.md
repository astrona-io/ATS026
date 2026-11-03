---
draft: true
exam_objectives:
- Know how to use Ingress controllers and Ingress resources
---
# Solution: Publish An Application Through An Ingress With TLS

Follow the request path from the controller to the application. Each step below finds one fault and repairs it.

## Step 1: The class

Read the class of the Ingress and the classes in the cluster:

```sh
kubectl -n starfleet get ingress portal
kubectl get ingressclass
```

The Ingress selects `legacy`. The controller string of `legacy` belongs to no running program, so nothing handles the Ingress. Traefik handles the class `traefik`. The fix is in the file that step 4 applies, where the class is `traefik`.

## Step 2: The empty Service

Compare the Service selector with the Pod labels and read the EndpointSlice:

```sh
kubectl -n starfleet get service web -o jsonpath='{.spec.selector}'
kubectl -n starfleet get pods --show-labels
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=web
```

The selector says `app: webb`, and the Pods have the label `app: web`. The Service selects no Pod, so its EndpointSlice has no ready address. Repair the selector:

```sh
kubectl -n starfleet patch service web --type merge -p '{"spec":{"selector":{"app":"web"}}}'
```

## Step 3: The backend port

Read the ports of the Service `api` and the backend of the `/api` path:

```sh
kubectl -n starfleet get service api -o jsonpath='{.spec.ports}'
kubectl -n starfleet get ingress portal -o jsonpath='{.spec.rules[0].http.paths[0].backend}'
```

The Service exposes port 80. The Ingress points at port 8080, which is the container port. An Ingress backend names a Service port, so the value must be 80.

## Step 4: Repair the Ingress and add TLS

Save this as `ingress-portal.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: portal
  namespace: starfleet
spec:
  ingressClassName: traefik
  tls:
  - hosts:
    - portal.local
    secretName: portal-tls
  rules:
  - host: portal.local
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web
            port:
              number: 80
```

Apply it:

```sh
kubectl apply -f ingress-portal.yaml
```

The `tls` entry makes the controller serve the certificate of the Secret for the host `portal.local`. The Secret holds the certificate and its key.

## Step 5: Test with verification

Send both requests from `shuttle`. The Pod has the certificate in `/certs/tls.crt`, and `--resolve` maps the name to the Service `traefik` without a DNS record. Read the cluster IP of the controller Service first:

```sh
kubectl -n ingress-system get service traefik -o jsonpath='{.spec.clusterIP}'
```

Replace `<TRAEFIK_IP>` with the value in the next two commands:

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 4 --cacert /certs/tls.crt --resolve portal.local:443:<TRAEFIK_IP> https://portal.local/
kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 4 --cacert /certs/tls.crt --resolve portal.local:443:<TRAEFIK_IP> https://portal.local/api/v1
```

The first answer names `web` and the second names `api` with the path `/api/v1`. Run `astrona submit -c .` and all checks pass. If a response is `404 page not found`, wait a few seconds for the controller to load the Ingress and send the request again.
