#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

kubectl -n starfleet patch configmap signal-conf --type merge -p '{"data":{"default.conf":"server {\n  listen 8080;\n  location / {\n    return 200 \"signal ready\\n\";\n  }\n}\n"}}'
kubectl -n starfleet rollout restart deployment/signal
kubectl -n starfleet rollout status deployment/signal --timeout=120s
kubectl -n starfleet patch service lantern --type merge -p '{"spec":{"ports":[{"port":80,"targetPort":9898}]}}'
kubectl -n starfleet patch service dock --type merge -p '{"spec":{"selector":{"app":"dock"}}}'

echo "[solution] Applied."
