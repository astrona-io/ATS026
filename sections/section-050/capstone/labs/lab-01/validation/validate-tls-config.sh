#!/usr/bin/env bash
set -uo pipefail
hosts=$(kubectl -n starfleet get ingress portal -o jsonpath='{.spec.tls[0].hosts[*]}' 2>/dev/null)
secret=$(kubectl -n starfleet get ingress portal -o jsonpath='{.spec.tls[0].secretName}' 2>/dev/null)
if [ "$hosts" = "portal.local" ] && [ "$secret" = "portal-tls" ]; then
  echo "PASS: TLS for portal.local uses the Secret portal-tls"
else
  echo "FAIL: tls hosts='$hosts' secretName='$secret'"
  exit 1
fi
