#!/usr/bin/env bash
set -euo pipefail
if [[ "$(kubectl config current-context)" != "kind-astro-ats-026-lab-060-01-01" ]]; then
  printf 'Refusing to operate on another Kubernetes context\n' >&2
  exit 1
fi
lab_directory="$(cd "$(dirname "$0")/.." && pwd)"
solution_directory="$lab_directory/solution"
node_name="astro-ats-026-lab-060-01-01-control-plane"
worker_name="astro-ats-026-lab-060-01-01-worker"
python3 "$solution_directory/repair-dns.py"
kubectl apply -f "$solution_directory/configmap-dns-repair.yaml"
kubectl -n kube-system rollout status deployment/coredns --timeout=240s
