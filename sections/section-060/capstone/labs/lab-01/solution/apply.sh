#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# 1. Recreate the Service as headless (clusterIP cannot be changed in place).
kubectl -n starfleet delete service crew
cat > "$WORK/service-crew.yaml" <<'YAML'
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
YAML
kubectl apply -f "$WORK/service-crew.yaml"

# 2. Add the rewrite rule as the first line of the .:53 block.
kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}' > "$WORK/Corefile.old"
awk '{print} /^\.:53 \{/ {print "    rewrite name exact deck.fleet.internal bridge.starfleet.svc.cluster.local"}' "$WORK/Corefile.old" > "$WORK/Corefile"
kubectl -n kube-system create configmap coredns --from-file=Corefile="$WORK/Corefile" --dry-run=client -o yaml > "$WORK/coredns.yaml"
kubectl apply -f "$WORK/coredns.yaml"

# 3. Scale CoreDNS and restart it so that every replica reads the new Corefile.
kubectl -n kube-system scale deployment coredns --replicas=3
kubectl -n kube-system rollout restart deployment/coredns
kubectl -n kube-system rollout status deployment/coredns --timeout=180s

# 4. Give the auditor its own resolver.
PARTNER_IP="$(kubectl -n starfleet get service partner-dns -o jsonpath='{.spec.clusterIP}')"
kubectl -n starfleet patch deployment auditor --type merge \
  -p "{\"spec\":{\"template\":{\"spec\":{\"dnsPolicy\":\"None\",\"dnsConfig\":{\"nameservers\":[\"${PARTNER_IP}\"],\"options\":[{\"name\":\"ndots\",\"value\":\"1\"}]}}}}}"
kubectl -n starfleet rollout status deployment/auditor --timeout=120s

echo "[solution] Applied."
