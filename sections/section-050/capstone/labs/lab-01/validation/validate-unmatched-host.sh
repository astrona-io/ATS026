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
body=$(https_get other.local / -k)
case "$body" in
  *"web host="*|*"api host="*) echo "FAIL: another host reached an application (got: $body)"; exit 1 ;;
esac
echo "PASS: another host did not reach an application"
