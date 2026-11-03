#!/usr/bin/env bash
set -uo pipefail
annotation='ingressclass\.kubernetes\.io/is-default-class'
traefik=$(kubectl get ingressclass traefik -o jsonpath="{.metadata.annotations.$annotation}" 2>/dev/null)
legacy=$(kubectl get ingressclass legacy -o jsonpath="{.metadata.annotations.$annotation}" 2>/dev/null)
if [ "$traefik" = "true" ] && [ "$legacy" != "true" ]; then
  echo "PASS: traefik is the only default IngressClass"
else
  echo "FAIL: default annotation on traefik='$traefik', on legacy='$legacy'"
  exit 1
fi
