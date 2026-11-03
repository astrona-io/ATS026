#!/usr/bin/env bash
set -uo pipefail
cluster_ip=$(kubectl -n starfleet get service probe-pods -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
selector=$(kubectl -n starfleet get service probe-pods -o jsonpath='{.spec.selector.app}' 2>/dev/null)
port=$(kubectl -n starfleet get service probe-pods -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
target=$(kubectl -n starfleet get service probe-pods -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)
if [ "$cluster_ip" = "None" ] && [ "$selector" = "probe" ] && [ "$port" = "80" ] && [ "$target" = "http" ]; then
  echo "PASS: probe-pods is headless, selects app=probe and uses port 80 with targetPort http"
else
  echo "FAIL: probe-pods must have clusterIP None, selector app=probe, port 80 and targetPort http (got clusterIP='$cluster_ip' selector='$selector' port='$port' targetPort='$target')"
  exit 1
fi
