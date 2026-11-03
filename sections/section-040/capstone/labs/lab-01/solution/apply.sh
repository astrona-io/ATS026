#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl label namespace outpost gateway-access=allowed --overwrite
kubectl apply -f "$DIR/solution.yaml"
kubectl -n outpost wait --for=jsonpath='{.status.parents[0].conditions[?(@.type=="Accepted")].status}'=True httproute/drifter --timeout=120s
kubectl -n starfleet wait --for=jsonpath='{.status.parents[0].conditions[?(@.type=="ResolvedRefs")].status}'=True httproute/stock --timeout=120s
kubectl -n starfleet wait --for=jsonpath='{.status.parents[0].conditions[?(@.type=="Accepted")].status}'=True httproute/scout --timeout=120s

echo "[solution] Applied."
