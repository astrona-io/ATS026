#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

PARTNER_IP="$(kubectl -n starfleet get service partner-dns -o jsonpath='{.spec.clusterIP}')"
kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}' > "$WORK/Corefile"
cat >> "$WORK/Corefile" <<BLOCK

partner.example:53 {
    errors
    cache 30
    forward . ${PARTNER_IP}
}
BLOCK
kubectl -n kube-system create configmap coredns --from-file=Corefile="$WORK/Corefile" --dry-run=client -o yaml > "$WORK/coredns.yaml"
kubectl apply -f "$WORK/coredns.yaml"
kubectl -n kube-system rollout restart deployment/coredns
kubectl -n kube-system rollout status deployment/coredns --timeout=180s

kubectl -n starfleet patch deployment shuttle --type merge \
  -p '{"spec":{"template":{"spec":{"dnsConfig":{"options":[{"name":"ndots","value":"2"}]}}}}}'
kubectl -n starfleet rollout status deployment/shuttle --timeout=120s

echo "[solution] Applied."
