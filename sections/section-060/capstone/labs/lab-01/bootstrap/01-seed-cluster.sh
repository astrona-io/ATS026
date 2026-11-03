#!/usr/bin/env bash
# Starting state for the CoreDNS capstone. Environment only: it creates the workloads, the partner DNS
# server and the faults (a ClusterIP Service in front of the StatefulSet, an auditor with default DNS).
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n starfleet rollout status deployment/probe --timeout=180s
kubectl -n starfleet rollout status deployment/bridge --timeout=180s
kubectl -n starfleet rollout status deployment/shuttle --timeout=180s
kubectl -n starfleet rollout status deployment/partner-dns --timeout=180s
kubectl -n starfleet rollout status deployment/auditor --timeout=180s
kubectl -n starfleet rollout status statefulset/crew --timeout=180s
echo "[lab] Ready."
