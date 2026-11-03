#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl -n starfleet patch configmap relay-conf --type merge -p '{"data":{"default.conf":"server {\n  listen 8080;\n  location / {\n    return 200 \"relay ready\\n\";\n  }\n}\n"}}'
kubectl -n starfleet rollout restart deployment/relay
kubectl -n starfleet rollout status deployment/relay --timeout=120s
kubectl -n starfleet patch service beacon --type merge -p '{"spec":{"ports":[{"port":80,"targetPort":9898}]}}'

echo "[solution] Applied."
