#!/usr/bin/env bash
# Starting state for "Isolate A Namespace With Network Policies". Environment only: it creates the workloads
# and the starting policies. It does not create anything the task asks the learner to build.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n starfleet rollout status deployment/scout --timeout=180s
kubectl -n starfleet rollout status deployment/probe --timeout=180s
kubectl -n starfleet rollout status deployment/shuttle --timeout=180s
kubectl -n starfleet rollout status deployment/bridge --timeout=180s
kubectl -n outpost rollout status deployment/probe --timeout=180s
kubectl -n outpost rollout status deployment/drifter --timeout=180s

echo "[lab] Ready."
