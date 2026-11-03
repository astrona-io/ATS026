#!/usr/bin/env bash
set -uo pipefail
port=$(kubectl -n starfleet get service probe -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
image=$(kubectl -n starfleet get deployment probe -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
label=$(kubectl -n starfleet get deployment probe -o jsonpath='{.spec.template.metadata.labels.tier}' 2>/dev/null)
generation=$(kubectl -n starfleet get deployment probe -o jsonpath='{.metadata.generation}' 2>/dev/null)
if [ "$port" = "80" ] && [ "$image" = "ghcr.io/stefanprodan/podinfo:6.15.0" ] && [ "$label" = "web" ] && [ "$generation" = "1" ]; then
  echo "PASS: the Deployment is unchanged and probe keeps port 80"
else
  echo "FAIL: the Deployment must not change and probe must keep port 80 (port='$port' tier='$label' generation='$generation')"
  exit 1
fi
