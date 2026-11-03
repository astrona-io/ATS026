#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl annotate ingressclass traefik ingressclass.kubernetes.io/is-default-class=true --overwrite
kubectl apply -f "$DIR/ingress-fleet.yaml"
sleep 5

echo "[solution] Applied."
