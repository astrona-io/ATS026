#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl -n starfleet patch service web --type merge -p '{"spec":{"selector":{"app":"web"}}}'
kubectl apply -f "$DIR/ingress-portal.yaml"
sleep 5

echo "[solution] Applied."
