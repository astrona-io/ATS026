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
backend=$(kubectl -n starfleet get ingress fleet -o jsonpath='{.spec.defaultBackend.service.name}:{.spec.defaultBackend.service.port.number}' 2>/dev/null)
if [ "$backend" != "fallback:80" ]; then echo "FAIL: spec.defaultBackend is '$backend', expected fallback:80"; exit 1; fi
body=$(wait_for_body fleet.local /nothing-here "fallback host=")
if [ $? -eq 0 ]; then echo "PASS: an unmatched path reached fallback"; else echo "FAIL: an unmatched path did not reach fallback (got: $body)"; exit 1; fi
