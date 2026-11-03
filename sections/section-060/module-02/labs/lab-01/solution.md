---
draft: true
exam_objectives:
- Understand and use CoreDNS
---
# Solution: Forward A Stub Domain And Tune Pod DNS

The solution has two changes. The first one adds a server block for the zone `partner.example` to the Corefile. The second one sets the `ndots` option in the `dnsConfig` of the `shuttle` Deployment.

## Step 1: Reproduce the failure

Query the partner name from the `shuttle` client. The default Corefile sends the query to the upstream resolvers of the node, which do not know the zone.

```sh
kubectl -n starfleet exec deploy/shuttle -- nslookup relic.partner.example.
```

The lookup fails with a "can't resolve" or "NXDOMAIN" style message. Run `astrona submit -c .` after each step to see which checks pass.

## Step 2: Find the address of the partner DNS server

The `forward` plugin needs an IP address. Read the ClusterIP of the Service `partner-dns` and keep it:

```sh
kubectl -n starfleet get service partner-dns -o jsonpath='{.spec.clusterIP}'
```

## Step 3: Add the stub domain to the Corefile

Print the current Corefile and keep a backup, then edit the ConfigMap:

```sh
kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}' > Corefile.backup
kubectl -n kube-system edit configmap coredns
```

Leave the whole `.:53 { ... }` block as it is. Add a second block after its closing brace, and replace `<PARTNER>` with the ClusterIP from the last step:

```
partner.example:53 {
    errors
    cache 30
    forward . <PARTNER>
}
```

A second server block handles every query whose name ends in `partner.example`. CoreDNS picks the block with the longest matching zone, so `partner.example` queries go to this block and all other names stay in `.:53`.

## Step 4: Make CoreDNS load the file

The `reload` plugin would load the change after about two minutes. Restart the Deployment to be sure and wait for the rollout:

```sh
kubectl -n kube-system rollout restart deployment/coredns
kubectl -n kube-system rollout status deployment/coredns --timeout=120s
```

If a Pod does not become ready, read its log with `kubectl -n kube-system logs -l k8s-app=kube-dns --tail=20` and look for a parse error, then compare your block with the one above.

Check both zones:

```sh
kubectl -n starfleet exec deploy/shuttle -- nslookup relic.partner.example.
kubectl -n starfleet exec deploy/shuttle -- nslookup probe.starfleet.svc.cluster.local
```

The first lookup returns `192.0.2.10`, the address that the partner server holds for `relic`. The second returns the ClusterIP of the Service `probe`.

## Step 5: Set ndots for the shuttle Deployment

The option belongs to the Pod template, so a patch changes it for all new Pods and starts a rollout. Save this as `shuttle-dnsconfig.yaml`:

```yaml
spec:
  template:
    spec:
      dnsConfig:
        options:
          - name: ndots
            value: "2"
```

Apply it as a patch:

```sh
kubectl -n starfleet patch deployment shuttle --patch-file shuttle-dnsconfig.yaml
kubectl -n starfleet rollout status deployment/shuttle --timeout=120s
```

Then check the file in the new Pod and the short name:

```sh
kubectl -n starfleet exec deploy/shuttle -- cat /etc/resolv.conf
kubectl -n starfleet exec deploy/shuttle -- wget -q -T 3 -O /dev/null http://probe/
```

The `options` line now holds `ndots:2`. The `dnsPolicy` is still `ClusterFirst`, so the `nameserver` and `search` lines are unchanged and the short name `probe` still resolves.

## Step 6: Submit

Run `astrona submit -c .` and remove the lab with `astrona destroy ats-026-lab-060-02-01` when you finish.
