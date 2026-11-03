#!/usr/bin/env bash
set -uo pipefail
selector=$(kubectl -n starfleet get networkpolicy probe-ingress -o jsonpath='{.spec.podSelector.matchLabels.app}' 2>/dev/null)
count=$(kubectl -n starfleet get networkpolicy --no-headers 2>/dev/null | wc -l | tr -d ' ')
if [ "$selector" = "probe" ] && [ "$count" = "1" ]; then echo "PASS: probe-ingress still selects app=probe and is the only policy in starfleet"; else echo "FAIL: probe-ingress selector='$selector', policies in starfleet=$count"; exit 1; fi
