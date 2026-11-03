---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Solution: CoreDNS Capstone

The four tasks are independent, so you can do them in any order. Run `astrona submit -c .` after each step to see which checks pass.

## Step 1: Read the starting state

Look at the Service and the Pod names of the StatefulSet, and try the per-Pod name from the client:

```sh
kubectl -n starfleet get service crew
kubectl -n starfleet exec deploy/shuttle -- nslookup crew-0.crew.starfleet.svc.cluster.local
```

The Service has a ClusterIP, so it is not headless, and the per-Pod name does not resolve. A per-Pod name exists only when the Service named in `serviceName` is headless.

## Step 2: Make the crew Service headless

The field `clusterIP` cannot be changed on an existing Service, so delete the Service and create it again. Leave the StatefulSet alone. Save this as `service-crew.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: crew
  namespace: starfleet
spec:
  clusterIP: None
  selector:
    app: crew
  ports:
    - name: http
      port: 80
      targetPort: http
```

```sh
kubectl -n starfleet delete service crew
kubectl apply -f service-crew.yaml
kubectl -n starfleet exec deploy/shuttle -- nslookup crew-0.crew.starfleet.svc.cluster.local
kubectl -n starfleet get pod crew-0 -o wide
```

The lookup returns the same address as the `IP` column of the Pod.

## Step 3: Add the rewrite rule

Keep a backup of the Corefile and edit the ConfigMap:

```sh
kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}' > Corefile.backup
kubectl -n kube-system edit configmap coredns
```

Inside the existing `.:53 { ... }` block, add one line. Do not remove any other line:

```
    rewrite name exact deck.fleet.internal bridge.starfleet.svc.cluster.local
```

The `rewrite` plugin changes the name in the query before the `kubernetes` plugin sees it, so the query is answered like a lookup of the `bridge` Service.

## Step 4: Scale CoreDNS and load the file

A change in the ConfigMap does not restart the Pods. Scale the Deployment and restart it, so that every replica reads the new file:

```sh
kubectl -n kube-system scale deployment coredns --replicas=3
kubectl -n kube-system rollout restart deployment/coredns
kubectl -n kube-system rollout status deployment/coredns --timeout=180s
```

If a Pod does not become ready, read `kubectl -n kube-system logs -l k8s-app=kube-dns --tail=20` and look for a parse error. Then test the rewrite and the Service address:

```sh
kubectl -n starfleet exec deploy/shuttle -- nslookup deck.fleet.internal.
kubectl -n starfleet get service bridge
```

Both show the same ClusterIP. Cluster names must still work, for example `nslookup probe.starfleet.svc.cluster.local`.

## Step 5: Give the auditor its own resolver

Read the address of the partner server and patch the Deployment. The policy `None` makes the Pod use only `dnsConfig`. Replace `<PARTNER>` with the ClusterIP. Save this as `auditor-dns.yaml`:

```yaml
spec:
  template:
    spec:
      dnsPolicy: None
      dnsConfig:
        nameservers:
          - <PARTNER>
        options:
          - name: ndots
            value: "1"
```

```sh
kubectl -n starfleet get service partner-dns -o jsonpath='{.spec.clusterIP}'
kubectl -n starfleet patch deployment auditor --patch-file auditor-dns.yaml
kubectl -n starfleet rollout status deployment/auditor --timeout=120s
kubectl -n starfleet exec deploy/auditor -- cat /etc/resolv.conf
kubectl -n starfleet exec deploy/auditor -- nslookup relic.partner.example.
```

The file has one `nameserver` line, no `search` line and `ndots:1`. The lookup returns `192.0.2.10`.

## Step 6: Submit

Run `astrona submit -c .` and remove the lab with `astrona destroy ats-026-lab-060-capstone-01` when you finish.
