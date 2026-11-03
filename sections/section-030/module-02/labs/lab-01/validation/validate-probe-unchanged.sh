#!/usr/bin/env bash
set -uo pipefail
cluster_ip=$(kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
port=$(kubectl -n starfleet get service probe -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
type=$(kubectl -n starfleet get service probe -o jsonpath='{.spec.type}' 2>/dev/null)
image=$(kubectl -n starfleet get deployment probe -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
ledger_image=$(kubectl -n outpost get deployment ledger -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ -n "$cluster_ip" ] && [ "$cluster_ip" != "None" ] && [ "$port" = "80" ] && [ "$type" = "ClusterIP" ] \
  && [ "$image" = "ghcr.io/stefanprodan/podinfo:6.15.0" ] && [ "$ledger_image" = "ghcr.io/stefanprodan/podinfo:6.15.0" ]; then
  echo "PASS: probe keeps its ClusterIP and port 80, and the images are unchanged"
else
  echo "FAIL: probe must stay a ClusterIP Service on port 80 and the images must not change"
  exit 1
fi
