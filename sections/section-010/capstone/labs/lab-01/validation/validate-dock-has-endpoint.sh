#!/usr/bin/env bash
set -uo pipefail
n=$(kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=dock -o jsonpath='{.items[*].endpoints[?(@.conditions.ready==true)].addresses[0]}' 2>/dev/null | wc -w | tr -d ' ')
if [ "$n" -ge 1 ]; then echo "PASS: Service dock has $n ready endpoint"; else echo "FAIL: Service dock has no ready endpoint"; exit 1; fi
