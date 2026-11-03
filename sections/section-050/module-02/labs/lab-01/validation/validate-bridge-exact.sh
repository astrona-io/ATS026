#!/usr/bin/env bash
set -uo pipefail
fetch() { kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 3 -H "Host: $1" "http://traefik.ingress-system.svc$2" 2>/dev/null; }
wait_for_body() { # host path expected-text
  local body=""
  for _ in $(seq 1 15); do
    body=$(fetch "$1" "$2") || true
    case "$body" in *"$3"*) echo "$body"; return 0 ;; esac
    sleep 2
  done
  echo "$body"; return 1
}
body=$(wait_for_body fleet.local /bridge "bridge host=fleet.local path=/bridge")
if [ $? -ne 0 ]; then echo "FAIL: /bridge on fleet.local did not reach bridge (got: $body)"; exit 1; fi
path_type=$(kubectl -n starfleet get ingress fleet -o jsonpath='{range .spec.rules[*].http.paths[?(@.path=="/bridge")]}{.pathType}{end}' 2>/dev/null)
if [ "$path_type" != "Exact" ]; then echo "FAIL: the /bridge path has pathType '$path_type', expected Exact"; exit 1; fi
longer=$(fetch fleet.local /bridge/extra)
case "$longer" in *"bridge host="*) echo "FAIL: /bridge/extra reached bridge but the path must be Exact"; exit 1 ;; esac
echo "PASS: /bridge is Exact and /bridge/extra does not reach bridge"
