#!/usr/bin/env bash
# Starting state: environment only. Creates the workloads, the Gateway "edge" and three routes that have faults.
# Status: UNTESTED (static checks only).
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
for app in scout-v1 scout-v2 echo shuttle; do
  kubectl -n starfleet rollout status deployment/$app --timeout=180s
done
kubectl -n catalog rollout status deployment/stock --timeout=180s
kubectl -n outpost rollout status deployment/drifter --timeout=180s
kubectl -n starfleet wait --for=condition=Programmed gateway/edge --timeout=300s
echo "[seed] Ready."
