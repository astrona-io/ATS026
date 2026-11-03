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
body=$(wait_for_body fleet.local /probe/status "probe host=fleet.local path=/probe/status")
if [ $? -eq 0 ]; then echo "PASS: /probe/status on fleet.local reached probe"; else echo "FAIL: /probe/status on fleet.local did not reach probe (got: $body)"; exit 1; fi
