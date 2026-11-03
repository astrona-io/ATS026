#!/usr/bin/env bash
set -uo pipefail
class=$(kubectl -n starfleet get ingress portal -o jsonpath='{.spec.ingressClassName}' 2>/dev/null)
if [ "$class" = "traefik" ]; then echo "PASS: portal selects the class traefik"; else echo "FAIL: portal selects class '$class', expected traefik"; exit 1; fi
