---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Repair Three Unreachable Workloads Solution

Work from the client side and read how each request ends. The way a request ends names the layer to inspect: a refusal points at the listener or the port, a timeout points at a missing backend.

## 1. Read how each request ends

Request each Service from the `drifter` Pod:

```sh
kubectl -n outpost exec deploy/drifter -- curl -sS --max-time 3 http://signal.starfleet.svc/
kubectl -n outpost exec deploy/drifter -- curl -sS --max-time 3 http://lantern.starfleet.svc/
kubectl -n outpost exec deploy/drifter -- curl -sS --max-time 3 http://dock.starfleet.svc/
```

All three names resolve, so the fault is not in DNS. The `signal` and `lantern` requests are refused. The `dock` request waits until the timeout.

## 2. Repair signal

The ConfigMap `signal-conf` holds the server configuration. Its `listen` directive names `127.0.0.1:8080`, so the server accepts connections only inside its own Pod. Change the directive to `listen 8080;`, then restart the Deployment, because NGINX reads the file at start:

```sh
kubectl -n starfleet edit configmap signal-conf
kubectl -n starfleet rollout restart deployment/signal
kubectl -n starfleet rollout status deployment/signal
```

## 3. Repair lantern

Compare the Service target port with the container port:

```sh
kubectl -n starfleet get service lantern -o jsonpath='{.spec.ports[*].targetPort}{"\n"}'
kubectl -n starfleet get deployment lantern -o jsonpath='{.spec.template.spec.containers[0].ports[*].containerPort}{"\n"}'
```

The Service forwards to 8080 and the container listens on 9898. Patch the Service:

```sh
kubectl -n starfleet patch service lantern --type merge -p '{"spec":{"ports":[{"port":80,"targetPort":9898}]}}'
```

## 4. Repair dock

The `dock` request times out and the port is correct, so check which Pods the Service selects:

```sh
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=dock
kubectl -n starfleet get service dock -o jsonpath='{.spec.selector}{"\n"}'
kubectl -n starfleet get pods --show-labels
```

The EndpointSlice has no address. The selector is `app: docks`, but the Pod label is `app: dock`. Patch the selector:

```sh
kubectl -n starfleet patch service dock --type merge -p '{"spec":{"selector":{"app":"dock"}}}'
```

## 5. Submit

```sh
astrona submit -c .
```

Every check should pass.
