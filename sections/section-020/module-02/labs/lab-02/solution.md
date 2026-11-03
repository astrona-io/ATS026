---
draft: true
exam_objectives:
- Define and enforce Network Policies
---
# Repair A Network Policy Solution

A request that times out while the Service has a backend points to a drop. Work from the Service to the policy to the labels and the port.

## 1. Confirm the Service has an endpoint

```sh
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe
```

The slice lists an address, so the Service has a backend and a policy is the likely cause.

## 2. Read the policy

```sh
kubectl -n starfleet describe networkpolicy probe-ingress
```

The policy protects the Pods labelled `app: probe`. It allows the source label `app: shutle` on TCP port 8081.

## 3. Compare with the real objects

```sh
kubectl -n starfleet get pods --show-labels
kubectl -n starfleet get deployment probe -o jsonpath='{.spec.template.spec.containers[0].ports[*].containerPort}{"\n"}'
```

The client is labelled `app: shuttle`, and the container listens on port 8080. The policy has a typo in the label and the wrong port.

## 4. Edit the policy

```sh
kubectl -n starfleet edit networkpolicy probe-ingress
```

Change the label to `shuttle` and the port to `8080`, then save.

## 5. Test both clients

```sh
kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' http://probe.starfleet.svc/
kubectl -n outpost exec deploy/drifter -- curl -s --max-time 3 -o /dev/null -w '%{http_code}\n' http://probe.starfleet.svc/
```

The first returns 200 and the second prints `000` after the timeout.

## 6. Submit

```sh
astrona submit -c .
```
