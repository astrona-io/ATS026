#!/usr/bin/env bash
set -uo pipefail
mode=$(kubectl -n starfleet get service probe -o jsonpath='{.spec.sessionAffinity}' 2>/dev/null)
timeout=$(kubectl -n starfleet get service probe -o jsonpath='{.spec.sessionAffinityConfig.clientIP.timeoutSeconds}' 2>/dev/null)
if [ "$mode" = "ClientIP" ] && [ "$timeout" = "600" ]; then
  echo "PASS: probe uses ClientIP affinity with a 600 second timeout"
else
  echo "FAIL: probe needs sessionAffinity ClientIP and timeoutSeconds 600 (got '$mode' and '$timeout')"
  exit 1
fi
