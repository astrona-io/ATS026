#!/usr/bin/env bash
# Starting state for "Route With The Default Class, Path Types And A Default Backend". Environment only:
# it creates the controller, the IngressClasses, the backends and the client. It does not create the
# Ingress or the default-class annotation that the task asks the learner to build.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n ingress-system rollout status deployment/traefik --timeout=180s
for name in scout probe bridge fallback shuttle; do
  kubectl -n starfleet rollout status "deployment/$name" --timeout=180s
done
echo "[lab] Ready."
