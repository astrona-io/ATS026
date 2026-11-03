#!/usr/bin/env bash
set -uo pipefail
kubectl -n starfleet rollout status deployment/shuttle --timeout=60s >/dev/null 2>&1 || { echo "FAIL: the shuttle rollout is not complete"; exit 1; }
resolv=$(kubectl -n starfleet exec deploy/shuttle -- cat /etc/resolv.conf 2>&1)
if ! echo "$resolv" | grep -Eq 'ndots:2([[:space:]]|$)'; then echo "FAIL: /etc/resolv.conf in shuttle does not contain ndots:2"; exit 1; fi
policy=$(kubectl -n starfleet get deployment shuttle -o jsonpath='{.spec.template.spec.dnsPolicy}')
if [ -n "$policy" ] && [ "$policy" != "ClusterFirst" ]; then echo "FAIL: dnsPolicy must stay ClusterFirst (got '$policy')"; exit 1; fi
if kubectl -n starfleet exec deploy/shuttle -- wget -q -T 3 -O /dev/null http://probe/ >/dev/null 2>&1; then echo "PASS: shuttle has ndots:2 and resolves probe"; else echo "FAIL: shuttle cannot resolve the short name probe"; exit 1; fi
