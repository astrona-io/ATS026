#!/usr/bin/env bash
set -uo pipefail
traefik_ip() { kubectl -n ingress-system get service traefik -o jsonpath="{.spec.clusterIP}" 2>/dev/null; }
https_get() { # host path [extra curl args]
  local host="$1" path="$2"; shift 2
  kubectl -n starfleet exec deploy/shuttle -- curl -s --max-time 4 --resolve "$host:443:$(traefik_ip)" "$@" "https://$host$path" 2>/dev/null
}
wait_for_https() { # host path expected-text
  local body=""
  for _ in $(seq 1 15); do
    body=$(https_get "$1" "$2" --cacert /certs/tls.crt) || true
    case "$body" in *"$3"*) echo "$body"; return 0 ;; esac
    sleep 2
  done
  echo "$body"; return 1
}
body=$(wait_for_https portal.local /api/v1 "api host=portal.local path=/api/v1")
if [ $? -eq 0 ]; then echo "PASS: https://portal.local/api/v1 reached api with a verified certificate"; else echo "FAIL: https://portal.local/api/v1 did not reach api (got: $body)"; exit 1; fi
