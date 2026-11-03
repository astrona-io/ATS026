---
draft: true
exam_objectives:
- Understand connectivity between Pods
---
# Repair Pods That Cannot Be Reached Solution

Work from the client side and read how each request ends. Both requests fail with a refused connection, which points to the listener or the port, not to a policy.

## 1. Find the cause for relay

Request the Service from `shuttle`:

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 http://relay.starfleet.svc/
```

The request is refused. The ConfigMap `relay-conf` holds the server configuration. Its `listen` directive names `127.0.0.1:8080`, so the server accepts connections only inside its own Pod.

## 2. Repair relay

Change the directive to `listen 8080;` in the ConfigMap, then restart the Deployment, because NGINX reads the file at start:

```sh
kubectl -n starfleet edit configmap relay-conf
kubectl -n starfleet rollout restart deployment/relay
kubectl -n starfleet rollout status deployment/relay
```

## 3. Find the cause for beacon

Compare the Service target port with the container port:

```sh
kubectl -n starfleet get service beacon -o jsonpath='{.spec.ports[*].targetPort}{"\n"}'
kubectl -n starfleet get deployment beacon -o jsonpath='{.spec.template.spec.containers[0].ports[*].containerPort}{"\n"}'
```

The Service forwards to 8080 and the container listens on 9898.

## 4. Repair beacon

```sh
kubectl -n starfleet patch service beacon --type merge -p '{"spec":{"ports":[{"port":80,"targetPort":9898}]}}'
```

## 5. Submit

```sh
astrona submit -c .
```

Every check should pass.
