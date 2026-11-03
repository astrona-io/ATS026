#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl apply -f "$DIR/solution.yaml"
kubectl -n starfleet wait --for=jsonpath='{.status.parents[0].conditions[?(@.type=="Accepted")].status}'=True httproute/scout --timeout=120s

echo "[solution] Applied."
